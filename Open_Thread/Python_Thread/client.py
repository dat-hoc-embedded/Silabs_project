from zeroconf import ServiceBrowser, Zeroconf

class MyListener:
    def add_service(self, zeroconf, type, name):
        info = zeroconf.get_service_info(type, name)
        if info:
            print(f"Found service: {name}")
            print(f"Address: {info.parsed_addresses()[0]}")
            print(f"Port: {info.port}")
            print(f"Properties: {info.properties}")

zeroconf = Zeroconf()
listener = MyListener()
browser = ServiceBrowser(zeroconf, "_iot._tcp.local.", listener)

try:
    input("Press enter to exit...\n")
finally:
    zeroconf.close()

# import requests
# url = "http://<ip>:8888"
# r = requests.get(url)
# print(r.text)
