import requests
import json
import os
EXEC_DIR = os.getenv('MY_CLASH_BASH_PWD')

url = "http://127.0.0.1:9090/logs"


response = requests.request("GET", url)
print("over")