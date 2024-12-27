import os
import http.server
import socketserver



# 设置要发布的静态文件目录
static_dir = "Razord-meta-gh-pages"
# static_dir = "yacd-gh-pages"
os.chdir("clash/page/"+static_dir)

# 设置端口
PORT = 34507

# 自定义请求处理器
class NoCacheHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # 设置 Cache-Control 头
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

# 创建请求处理器
Handler = NoCacheHTTPRequestHandler

# 使用 socketserver 启动 HTTP 服务器
with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    print(f"Open http://localhost:{PORT}/")
    httpd.serve_forever()
