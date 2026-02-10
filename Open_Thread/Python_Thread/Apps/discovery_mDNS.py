"""
Docstring for Apps.discovery_mDNS
@summary: Quét và phát hiện dịch vụ mDNS trên mạng LAN sử dụng Zeroconf.
@author: embeddat
@date: 2024-12-23

"""
# Import thư viện cần thiết từ zeroconf: 
# ServiceBrowser để quét dịch vụ mDNS
# ServiceListener để lắng nghe sự kiện dịch vụ mDNS
# Zeroconf để quản lý mDNS
from zeroconf import Zeroconf, ServiceBrowser, ServiceListener
import socket, time # Dùng để xử lý địa chỉ IP và tạm dừng chương trình

SERVICE_TYPE = "_apptest._udp.local."

# Hàm định dạng địa chỉ IP từ bytes sang string
def fmt_ip(addr_bytes):
    # addr_bytes may be IPv4/IPv6 packed
    if len(addr_bytes) == 16:
        return socket.inet_ntop(socket.AF_INET6, addr_bytes) # AF_INET6 for IPv6
    if len(addr_bytes) == 4:
        return socket.inet_ntop(socket.AF_INET, addr_bytes)
    return None

class Listener(ServiceListener):
    def add_service(self, zc, type_, name):
        info = zc.get_service_info(type_, name, timeout=2000)
        if not info:
            return
        ips = [fmt_ip(a) for a in info.addresses]
        ips = [ip for ip in ips if ip]
        # Nếu không có địa chỉ trong info.addresses, thử resolve hostname (fallback)
        if not ips:
            try:
                hostname = info.server.rstrip('.')
                addrs = socket.getaddrinfo(hostname, None)
                ips = []
                for fam, _socktype, _proto, _canonname, sockaddr in addrs:
                    if fam == socket.AF_INET:
                        ips.append(sockaddr[0])
                    elif fam == socket.AF_INET6:
                        ips.append(sockaddr[0])
                # loại bỏ trùng lặp, giữ thứ tự
                ips = list(dict.fromkeys(ips))
            except Exception:
                pass

        print("FOUND:", name)
        print("  host:", info.server) # Tên host cung cấp dịch vụ
        print("  port:", info.port) # Cổng dịch vụ
        print("  ips :", ips) # Danh sách địa chỉ IP (có thể rỗng)

        # Build safe TXT dict: handle bytes/None values gracefully
        txt = {}
        for k, v in info.properties.items():
            try:
                key = k.decode() if isinstance(k, (bytes, bytearray)) else str(k)
            except Exception:
                key = repr(k)
            if v is None:
                val = None
            else:
                try:
                    val = v.decode(errors="ignore") if isinstance(v, (bytes, bytearray)) else str(v)
                except Exception:
                    val = repr(v)
            txt[key] = val

        print("  txt :", txt)

zc = Zeroconf()
browser = ServiceBrowser(zc, SERVICE_TYPE, Listener())

try:
    while True:
        time.sleep(1) # Giữ chương trình chạy để tiếp tục quét dịch vụ
except KeyboardInterrupt:
    print("Exiting...") 
    pass
# finally:
#     zc.close() # Đóng Zeroconf khi thoát chương trình, giải phóng tài nguyên mạng socket multicast
