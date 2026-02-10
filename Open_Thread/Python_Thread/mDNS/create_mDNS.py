"""Tạo một dịch vụ mDNS sử dụng thư viện Zeroconf trong Python."""

# import class ServiceInfo  từ zeroconf: dùng để định nghĩa dịch vụ mDNS
# import class Zeroconf: dùng để khởi tạo và quản lý dịch vụ mDNS
from zeroconf import Zeroconf, ServiceInfo 
import socket # Dùng để chuyển đổi địa chỉ IP sang dạng byte

info = ServiceInfo(
    "_embeddatpy._tcp.local.", # Service type
    "My Embedded Device._embeddatpy._tcp.local.", # Service instance name
    #addresses=[b"\x0A\xCA\x76\x63"], # Địa chỉ IP ở dạng byte của host cung cấp mDNS: 10.202.118/99
    addresses=[socket.inet_aton("10.202.118.99")], # Chuyển đổi địa chỉ IP từ dạng string sang byte
    port=8080, # Port TCP/UDP mà dịch vụ lắng nghe 
    # TXT records: thông tin bổ sung về dịch vụ. Một dict với các cặp key-value
    properties={"version": "1.0", "path": "/status", "author": "embeddat"},
)

# Khởi tạo Zeroconf và đăng ký dịch vụ mDNS, tự động mở socket, lắng nghe và gửi multicast packets theo chuẩn mDNS
zeroconf = Zeroconf()
# Đăng dịch vụ lên mạng cục bộ. Zeroconf sẽ gửi gói mDNS (ADVERTISE) để các client trên cùng mạng có thể phát hiện dịch vụ.
zeroconf.register_service(info)

input("Dịch vụ mDNS đang chạy. Nhấn Enter để thoát...\n")

# Hủy đăng ký dịch vụ mDNS và đóng Zeroconf, giải phóng tài nguyên mạng
zeroconf.unregister_service(info)
# Đóng đối tượng Zeroconf, giải phóng socket, stop multicast listener, và dọn sạch tài nguyên
zeroconf.close()

