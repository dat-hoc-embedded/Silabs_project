from zeroconf import Zeroconf, ServiceBrowser
import requests # Dùng để gửi HTTP requests (curl thay thế)
import time

# Lớp listener để xử lý các dịch vụ mDNS được phát hiện
class MyListener:
    def __init__(self):
        self.service_info = None # Lưu thông tin dịch vụ khi tìm thấy
    def add_service(self, zeroconf, type, name): # Hàm gọi khi tìm thấy dịch vụ mới
        info = zeroconf.get_service_info(type, name) # Lấy thông tin dịch vụ
        if info: # Nếu có thông tin dịch vụ
            print(f"🔎 Đã tìm thấy dịch vụ: {name}")
            address = info.parsed_addresses()[0]   # Lấy địa chỉ IP của thiết bị
            port = info.port                       # Lấy port từ file .service
            props = info.properties                # Lấy TXT records
            print(f"➡ Địa chỉ: {address}, Port: {port}, Thuộc tính: {props}")
            for key, value in props.items():
                try:
                    print(f"   - {key.decode('utf-8')}: {value.decode('utf-8')}")  
                except:
                    print(f"   - {key}: {value}")
            self.service_info = (address, port) # Lưu lại để dùng sau
def main():
    zeroconf = Zeroconf() # Khởi tạo Zeroconf để quét mDNS
    listener = MyListener() # Tạo listener
    browser = ServiceBrowser(zeroconf, "_embeddatpy._tcp.local.", listener) # Bắt đầu quét dịch vụ mDNS loại _embeddatpy._tcp.local.

    print("Scanning mDNS _embeddatpy._tcp.local. trên mạng LAN...")
    # Đợi đến khi listener.service_info được thiết lập hoặc timeout
    timeout = 30.0  # giây, điều chỉnh nếu cần
    start = time.time()
    while listener.service_info is None and (time.time() - start) < timeout:
        time.sleep(0.1) 

    if listener.service_info is None:
        print(f"⌛ Timeout sau {timeout} giây — không tìm thấy dịch vụ.")
    else:
        print("✅ Đã tìm thấy dịch vụ; xử lý tiếp...")

    if listener.service_info:
        ip, port = listener.service_info
        url = f"http://{ip}:{port}/led/on"   # URL để gửi request
        print(f"🌐 Gửi HTTP GET đến {url}")
        try:
            response = requests.get(url)
            print("✅ Trạng thái phản hồi:", response.status_code)
            print("📄 Nội dung phản hồi:", response.text)
        except Exception as e:
            print("❌ Lỗi khi gửi request:", e)
    else:
        print("Không tìm thấy dịch vụ embeddatpy nào.")

    zeroconf.close()

if __name__ == "__main__":
    main()