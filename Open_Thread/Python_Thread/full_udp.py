"""
Discover a Thread device service via OTBR mDNS (Avahi) and send a command over UDP.

- Browses: _apptest._udp.local.
- Matches instance name: embeddat-device
- Resolves host/port/IPv6 via zeroconf
- Sends UDP payload: "led on\n" (default) or any command you pass
- Optionally waits for an ACK (if your device replies)

Usage:
  python3 mdns_send_led_udp.py
  python3 mdns_send_led_udp.py "led off"
"""
import sys
import time
import socket
from typing import Optional, List, Dict

from zeroconf import Zeroconf, ServiceBrowser, ServiceListener

# IMPORTANT: must match what OTBR advertises on LAN
SERVICE_TYPE = "_apptest._udp.local."
TARGET_INSTANCE = "embeddat-device"


def bytes_to_ip(addr: bytes) -> Optional[str]:
    try:
        if len(addr) == 16:
            return socket.inet_ntop(socket.AF_INET6, addr)
        if len(addr) == 4:
            return socket.inet_ntop(socket.AF_INET, addr)
    except OSError:
        return None
    return None


def prefer_ipv6(ips: List[str]) -> Optional[str]:
    v6 = [ip for ip in ips if ":" in ip]
    if v6:
        # Prefer ULA/Thread-ish first if present (fdxx::/8), else first IPv6
        ula = [ip for ip in v6 if ip.lower().startswith("fd")]
        return ula[0] if ula else v6[0]
    v4 = [ip for ip in ips if "." in ip]
    return v4[0] if v4 else None


class FoundService:
    def __init__(self):
        self.name: Optional[str] = None
        self.server: Optional[str] = None
        self.port: Optional[int] = None
        self.ips: List[str] = [] 
        self.txt: Dict[str, str] = {} 


class Listener(ServiceListener):
    def __init__(self, zc: Zeroconf, target_instance: str):
        self.zc = zc
        self.target_instance = target_instance
        self.found = FoundService() # kết quả dịch vụ được tìm thấy: name, server, port, ips, txt
        self._done = False # private flag: đã tìm thấy và phân giải dịch vụ chưa

    @property
    def done(self) -> bool:  # false: not done yet, true: found and resolved
        return self._done 

    def add_service(self, zc: Zeroconf, type_: str, name: str) -> None: 
        # name looks like: "<instance>._apptest._udp.local."
        instance = name.split("._")[0]
        if instance != self.target_instance:  # not the target instance
            return # 

        print(f"[mDNS] Found candidate instance: {name}")

        info = zc.get_service_info(type_, name, timeout=2500)
        if not info:
            print("[mDNS] get_service_info() timeout/no info yet, waiting...")
            return

        ips = []
        for a in info.addresses:
            ip = bytes_to_ip(a)
            if ip:
                ips.append(ip)

        # Fallback 1: some zeroconf versions expose parsed_addresses() returning str IPs
        if not ips and hasattr(info, "parsed_addresses"):
            print("[mDNS] No addresses in info.addresses, trying parsed_addresses()...")
            try:
                parsed = info.parsed_addresses()
                if parsed:
                    ips = [p for p in parsed if p]
            except Exception:
                pass

        # Fallback 2: try resolving the hostname advertised in info.server
        if not ips:
            print("[mDNS] No addresses in info.addresses, trying to resolve hostname...")
            try:
                hostname = info.server.rstrip('.')
                addrs = socket.getaddrinfo(hostname, None)
                for fam, _socktype, _proto, _canonname, sockaddr in addrs:
                    if fam == socket.AF_INET:
                        ips.append(sockaddr[0])
                    elif fam == socket.AF_INET6:
                        ips.append(sockaddr[0])
                # remove duplicates, keep order
                ips = list(dict.fromkeys(ips))
            except Exception:
                pass

        txt = {}
        for k, v in info.properties.items():
            try:
                # Decode key and value as UTF-8, ignore errors.  
                key = k.decode("utf-8", "ignore") if isinstance(k, (bytes, bytearray)) else str(k)
            except Exception:
                key = repr(k) # fallback to repr on error: bytes that can't decode (b'\xff') -> ensure always a string

            if v is None:   
                val = None
            else:
                try:
                    val = v.decode("utf-8", "ignore") if isinstance(v, (bytes, bytearray)) else str(v)
                except Exception:
                    val = repr(v)
            txt[key] = val

        self.found.name = name
        self.found.server = info.server
        self.found.port = info.port
        self.found.ips = ips
        self.found.txt = txt

        print("[mDNS] Resolved service:")
        print(f"       server: {self.found.server}")
        print(f"       port  : {self.found.port}")
        print(f"       ips   : {self.found.ips}")
        print(f"       txt   : {self.found.txt}")

        self._done = True

    def update_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        self.add_service(zc, type_, name)

    def remove_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        pass

# ip : str (type hint), -> bytes (return type hint)
def udp_send(ip: str, port: int, payload: bytes, wait_ack: bool = True, timeout_s: float = 2.0) -> bytes:
    """Send UDP payload and optionally wait for one reply datagram."""
    af = socket.AF_INET6 if ":" in ip else socket.AF_INET #
    sock = socket.socket(af, socket.SOCK_DGRAM)
    sock.settimeout(timeout_s)

    # Send
    if af == socket.AF_INET6:
        sock.sendto(payload, (ip, port, 0, 0))
    else:
        sock.sendto(payload, (ip, port))

    if not wait_ack:
        sock.close()
        return b""

    # Receive ACK (if device replies)
    try:
        data, addr = sock.recvfrom(2048) # Receive up to 2048 bytes
        print(f"[udp] recv from {addr}: {data!r}")
        return data
    except socket.timeout:
        print("[udp] no ack (timeout) — this is OK if your device doesn't reply.")
        return b""
    finally:
        sock.close()

def main():
    cmd = "led on" if len(sys.argv) < 2 else sys.argv[1]  # Get command from args
    payload = (cmd.strip() + "\n").encode("utf-8") # strip : whitespace, add newline, encode

    print(f"[cfg] Browse service type: {SERVICE_TYPE}") # 
    print(f"[cfg] Target instance   : {TARGET_INSTANCE}") # 
    print(f"[cfg] Command to send   : {cmd!r}") # 

    zc = Zeroconf() # create Zeroconf instance
    listener = Listener(zc, TARGET_INSTANCE)  # create listener
    browser = ServiceBrowser(zc, SERVICE_TYPE, listener) # start browsing

    deadline = time.time() + 15.0 # 15s timeout
    try:
        while (not listener.done) and time.time() < deadline:  #  wait until done or timeout
            time.sleep(0.2) # sleep a bit to avoid busy loop

        if not listener.done: # timeout waiting for service 
            raise SystemExit(   # exit with error    
                "[ERR] Timeout: service not found.\n"  # 
                "Check with: avahi-browse -rt _apptest._udp" #  
            )

        if listener.found.port is None: # no port found
            raise SystemExit("[ERR] Service resolved but no port.") # exit with no port

        ip = prefer_ipv6(listener.found.ips) # prefer IPv6 if available
        if not ip:
            raise SystemExit("[ERR] Service resolved but no IP address (AAAA/A).") # exit with no IP

        port = listener.found.port
        print(f"[net] Selected target: [{ip}]:{port}")
        print(f"[net] UDP send: {payload!r}")


        # Try sending to the selected IP; if network is unreachable (Windows 10051)
        # try other resolved addresses as a fallback.
        send_success = False
        tried = []
        # build candidate list: prefer the chosen ip first, then others
        candidates = [ip] + [x for x in listener.found.ips if x != ip]
        for candidate in candidates:
            try:
                print(f"[net] attempting send to {candidate}:{port}")
                udp_send(candidate, port, payload, wait_ack=True, timeout_s=2.0) 
                print("[OK] Done.")
                send_success = True
                break
            except OSError as e:
                tried.append((candidate, e))
                print(f"[warn] send to {candidate} failed: {e}")

        if not send_success:
            # Diagnostic help: list tried addresses and last error
            errs = ", ".join(f"{c} ({err})" for c, err in tried)
            raise SystemExit(
                "[ERR] All send attempts failed.\n"
                f"Tried addresses: {errs}\n"
                "Possible causes: no route to target IPv6, missing scope id for link-local addresses, or firewall.\n"
                "Suggestions: ensure the host has a route to the target, try an IPv4 address, or add appropriate interface scope for link-local addresses."
            )
    finally:
        try:
            zc.close()
        except Exception:
            pass


if __name__ == "__main__":
    main()
