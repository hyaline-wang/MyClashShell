import socket

def send_message():
    client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # 使用UDP
    server_address = ('127.0.0.1', 12345)  # 服务器IP地址和端口

    message = "Hello, Server!"
    client.sendto(message.encode('utf-8'), server_address)  # 发送数据到服务器

    data, server = client.recvfrom(1024)  # 接收服务器的响应
    print(f"Received response: {data.decode('utf-8')}")

    client.close()

if __name__ == "__main__":
    send_message()
    import sys
    print(sys.argv)
    command = sys.argv[2]
    if command == "check_proxy":
        print("check_proxy")