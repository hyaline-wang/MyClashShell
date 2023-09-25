import requests
import json
import os
EXEC_DIR = os.getenv('MY_CLASH_BASH_PWD')

url = "http://127.0.0.1:9090/configs"

payload = json.dumps({
  "path": EXEC_DIR+"../clash/configs/config.yaml"
})
headers = {
  'Content-Type': 'application/json'
}

response = requests.request("PUT", url, headers=headers, data=payload)
if(response.text):
    print(response.text)
else:
    print("OK")