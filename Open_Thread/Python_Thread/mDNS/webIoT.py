# Flask để tạo web server đơn giản. Class Flask cung cấp các route để xử lý các yêu cầu HTTP
# jsonify để trả về dữ liệu JSON

from flask import Flask, jsonify 
import serial # Thư viện để giao tiếp qua UART

# Mở cổng UART tới board STM32/EFR32
# ser = serial.Serial('/dev/ttyACM0', 115200, timeout=1)

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"status": "ok", "device": "Dat IoT", "version": "1.0"}) # Trả về JSON khi truy cập root

@app.route("/led/on")
def led_on():
    # Ở đây bạn có thể viết code bật LED thật qua GPIO
    # ser.write(b"LED:ON\n")
    # resp = ser.readline().decode().strip()

    return jsonify({"result": "LED turned ON "}) # Trả về JSON

@app.route("/led/off") # Route để tắt LED
def led_off():
    # Code tắt LED thật
    # ser.write(b"LED:OFF\n")
    # resp = ser.readline().decode().strip()

    return jsonify({"result": "LED turned OFF"}) # Trả về JSON

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)  # Chạy web server trên tất cả các giao diện mạng, port 8080