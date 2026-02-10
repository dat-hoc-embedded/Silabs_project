"""
Discover a Thread device service advertised via OTBR mDNS (Avahi) and send a command over TCP.

- Browses: _apptest._tcp.local.
- Matches instance name: embeddat-device
- Resolves host/port/IPv6 via zeroconf
- Connects TCP and sends: "led on\n" (default) or any command you pass

Usage:
  python3 mdns_send_led.py                 # sends "led on"
  python3 mdns_send_led.py "led off"       # sends "led off"
"""

import sys  # For command-line arguments
import time # For sleep and timeouts
import socket # For networking
from typing import Optional, List, Dict # For type hints

from zeroconf import Zeroconf, ServiceBrowser, ServiceListener # mDNS/zeroconf library: Zeroconf, ServiceBrowser, ServiceListener

SERVICE_TYPE = "_apptest._tcp.local." # mDNS service type to browse
TARGET_INSTANCE = "embeddat2-device"  # SRP instance you showed


# Bytes is expected variable of this function
def bytes_to_ip(addr: bytes) -> Optional[str]:
    """Convert packed IPv4/IPv6 bytes to string."""
    try:
        if len(addr) == 16:
            return socket.inet_ntop(socket.AF_INET6, addr)
        if len(addr) == 4:
            return socket.inet_ntop(socket.AF_INET, addr)
    except OSError:
        return None
    return None


def prefer_ipv6(ips: List[str]) -> Optional[str]:
    """Pick a best IP: prefer IPv6 (Thread ULA/OMR), fallback IPv4."""
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
        self.found = FoundService()
        self._done = False

    @property
    def done(self) -> bool:
        return self._done

    def add_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        # name format: "<instance>._apptest._tcp.local."
        instance = name.split("._")[0]  # safe enough for normal instance names
        if instance != self.target_instance:
            return

        print(f"[mDNS] Found candidate instance: {name}")

        info = zc.get_service_info(type_, name, timeout=2500)
        if not info:
            print("[mDNS] get_service_info() timeout/no info yet, will wait for next event...")
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
        # Some networks announce then update; handle same as add
        self.add_service(zc, type_, name)

    def remove_service(self, zc: Zeroconf, type_: str, name: str) -> None:
        pass


def tcp_send(ip: str, port: int, payload: bytes, timeout_s: float = 3.0) -> bytes:
    """Send payload over TCP and read one reply chunk (optional)."""
    af = socket.AF_INET6 if ":" in ip else socket.AF_INET
    s = socket.socket(af, socket.SOCK_STREAM) 
    s.settimeout(timeout_s)

    # For IPv6 connect tuple is (host, port, flowinfo, scopeid)
    if af == socket.AF_INET6:
        print("socket connect")
        s.connect((ip, port, 0, 0))
    else:
        s.connect((ip, port))

    print("socket sendall")
    s.sendall(payload)

    # Try to read a reply, but don't block too long
    try:
        resp = s.recv(2048)
    except socket.timeout:
        resp = b""
    finally:
        s.close()

    return resp


def main():
    cmd = "led on" if len(sys.argv) < 2 else sys.argv[1]  # Get command from args
    payload = (cmd.strip() + "\n").encode("utf-8") # strip : whitespace, add newline, encode

    print(f"[cfg] Browse service type: {SERVICE_TYPE}") 
    print(f"[cfg] Target instance   : {TARGET_INSTANCE}")
    print(f"[cfg] Command to send   : {cmd!r}")

    zc = Zeroconf()
    listener = Listener(zc, TARGET_INSTANCE)
    browser = ServiceBrowser(zc, SERVICE_TYPE, listener)

    # Wait until found or timeout
    deadline = time.time() + 15.0
    try:
        while not listener.done and time.time() < deadline:
            time.sleep(0.2)

        if not listener.done:
            raise SystemExit(
                "[ERR] Timeout: service not found. "
                "Check with: avahi-browse -rt _apptest._tcp"
            )

        if listener.found.port is None:
            raise SystemExit("[ERR] Service resolved but no port.")

        ip = prefer_ipv6(listener.found.ips)
        if not ip:
            raise SystemExit("[ERR] Service resolved but no IP address (AAAA/A).")

        port = listener.found.port
        print(f"[net] Selected target: [{ip}]:{port}")

        print(f"[net] TCP connect + send: {payload!r}")
        resp = tcp_send(ip, port, payload)
        print(f"[net] Response: {resp!r}" if resp else "[net] No response (timeout or server sent nothing).")

        print("[OK] Done.")
    finally:
        # Ensure cleanup
        try:
            zc.close()
        except Exception:
            pass


if __name__ == "__main__":
    main()
