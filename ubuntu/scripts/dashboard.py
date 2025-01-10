import os
import http.server
import socketserver
import sys
import yaml
import threading
import socket
import time
# 自定义请求处理器
class NoCacheHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # 设置 Cache-Control 头
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

class Dashboard():
    def __init__(self):
        ROOT_PWD = os.getenv('MYCLASH_ROOT_PWD',default=os.getcwd())
        self.cfg_path = f"{ROOT_PWD}/user_config.yaml"
        self.port = 34507
        self.server_thread = None
        self.httpd = None
        with open(self.cfg_path, "r") as stream:
            try:
                    dictionary = yaml.safe_load(stream)
                    # read cfg
                    # read env var,default is "Razord-meta-gh-pages"
                    # static_dir = "Razord-meta-gh-pages"
                    # static_dir = "yacd-gh-pages"
                    web_page = dictionary.get("web_page")
                    if web_page is None:
                        web_page = "Razord-meta-gh-pages"
                    elif web_page != "Razord-meta-gh-pages" and web_page != "yacd-gh-pages":
                        print("web_page is not valid,use default(Razord-meta-gh-pages)")
                        web_page = "Razord-meta-gh-pages"
                    self.static_dir = web_page

                    self.current_proxy = dictionary.get("default_subscribe")
            except SystemExit:
                pass
            except :
                print("failed")
    def start_server(self):
        """启动 HTTP 服务器"""
        if self.server_thread is not None and self.server_thread.is_alive():
            print("Server is already running.")
            return
        self.server_thread = threading.Thread(target=self.dashboard)
        self.server_thread.start()
    def restart_server(self):
        """重启 HTTP 服务器"""
        if self.server_thread is not None:
            print("Stopping the server...")
            self.stop_server()
            time.sleep(1)  # 给服务器一点时间关闭

        print("Starting the server...")
        self.server_thread = threading.Thread(target=self.dashboard)
        self.server_thread.start()
    def stop_server(self):
        """停止 HTTP 服务器"""
        if self.httpd is not None:
            print("Shutting down the server...")
            self.httpd.shutdown()
            self.server_thread.join()  # 等待线程完成
            self.httpd.server_close()
            self.httpd = None
            print("Server stopped.")
    def dashboard(self):
        # 设置要发布的静态文件目录
        os.chdir("clash/page/"+self.static_dir)
        print(self.static_dir)

        # 使用 socketserver 启动 HTTP 服务器
        Handler = NoCacheHTTPRequestHandler
        print("Starting server...")
        self.httpd = socketserver.TCPServer(("127.0.0.1", self.port), Handler)
        print(f"Serving at port {self.port}")
        print(f"Open http://localhost:{self.port}/")
        # 开始服务
        self.httpd.serve_forever()
    def easy_db_daemon(self):
        '''
        创建一个后台线程，通过IPC方式与主线程通信
        '''
        server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # 使用UDP
        server.bind(('127.0.0.1', 12345))  # 绑定到所有可用的IP地址和端口12345
        print("Server listening on port 12345...")

        while True:
            data, addr = server.recvfrom(1024)  # 接收来自客户端的数据
            if data:
                print(f"Received message: {data.decode('utf-8')} from {addr}")
                server.sendto(b"Response from server", addr)  # 向客户端发送响应

# threading.Thread(target=httpd.serve_forever).start()
if __name__ == "__main__":
    dashboard = Dashboard()
    dashboard.start_server()
    dashboard.easy_db_daemon()

