#!/usr/bin/python
import subprocess, sys
import os
import warnings 
import traceback
import yaml
import requests
import json
def temp_source_config(yaml_path): 
    url = "http://127.0.0.1:9090/configs"
    payload = json.dumps({
    "path": yaml_path
    })
    headers = {
    'Content-Type': 'application/json'
    }

    response = requests.request("PUT", url, headers=headers, data=payload)
    if(response.text):
        print(response.text)
        return False
    else:
        return True

myclash_root_pwd = os.getenv('MYCLASH_ROOT_PWD') # None
if myclash_root_pwd is None:
    raise TypeError("[ERROR] 找不到 MYCLASH_ROOT_PWD;请尝试 source /etc/bash.bashrc ;source ~/.bashrc 然后重新运行")

raw_configs_pwd = "{}/clash/raw_configs".format(myclash_root_pwd)
final_configs_pwd = "{}/clash/final_configs".format(myclash_root_pwd)
user_config_path = myclash_root_pwd+'/config.yaml'

print("Delete old raw_config")
subprocess.run("rm -rf {}".format(raw_configs_pwd), shell = True, executable="/bin/bash")
subprocess.run("mkdir {}".format(raw_configs_pwd), shell = True, executable="/bin/bash")
# print(subprocess.run("rm -rf {}".format(raw_configs_pwd), shell = True, executable="/bin/bash").returncode)
# print(subprocess.run("mkdir {}".format(raw_configs_pwd), shell = True, executable="/bin/bash").returncode)
# print("download new raw_config")

# read yaml
download_configs = []
default_subcribe = None
with open(user_config_path, "r") as stream:
    try:
        dictionary = yaml.safe_load(stream)
        default_subcribe = dictionary.get("default_subscribe")
        sub_dict = dictionary.get("subscribes")
        if(sub_dict is None):
            raise TypeError("[ERROR] 没有找到订阅信息")
        for key, value in sub_dict.items():
            print("Download {} config".format(key))
            x = requests.get(value+"&flag=clash")
            f = open(raw_configs_pwd+"/{}.yaml".format(key), "w")
            f.write(x.text)
            f.close()   
            download_configs.append(key)        
    except SystemExit:
        pass
    # except :
    #     print("failed")

# merge_config
    
print("Delete old merge_config")
subprocess.run("rm -rf {}".format(final_configs_pwd), shell = True, executable="/bin/bash")
subprocess.run("mkdir {}".format(final_configs_pwd), shell = True, executable="/bin/bash")
# print(subprocess.run("rm -rf {}".format(final_configs_pwd), shell = True, executable="/bin/bash").returncode)
# print(subprocess.run("mkdir {}".format(final_configs_pwd), shell = True, executable="/bin/bash").returncode)
# print("merge custum configs")
if(len(download_configs) == 0):
    print("[error] 没有找到任何可用的代理")
    exit()
import merge_proxy
custum_proxy_path = myclash_root_pwd + "/custom_configs"
for i in download_configs:
    print("merge {} configs".format(i))
    merge_proxy.merge_one_config(raw_pwd= raw_configs_pwd,
                                custum_pwd=custum_proxy_path,
                                final_pwd=final_configs_pwd,
                                config_name=i)
print("代理更新完成")

# if (default_subcribe is None):
#     subprocess.run("ln -s {}/{}.yaml {}/clash/configs/config.yaml".format(final_configs_pwd,download_configs[0],myclash_root_pwd), shell = True, executable="/bin/bash")
if (default_subcribe in download_configs):
    print("代理使用: {}".format(default_subcribe))
    subprocess.run("rm {}/clash/configs/config.yaml".format(myclash_root_pwd), shell = True, executable="/bin/bash")
    subprocess.run("ln -s {}/{}.yaml {}/clash/configs/config.yaml".format(final_configs_pwd,default_subcribe,myclash_root_pwd), shell = True, executable="/bin/bash")
    temp_source_config("{}/clash/configs/config.yaml".format(myclash_root_pwd))
else:
    print("未找到匹配的默认代理，代理使用: {}".format(download_configs[0]))
    subprocess.run("rm {}/clash/configs/config.yaml".format(myclash_root_pwd), shell = True, executable="/bin/bash")
    subprocess.run("ln -s {}/{}.yaml {}/clash/configs/config.yaml".format(final_configs_pwd,download_configs[0],myclash_root_pwd), shell = True, executable="/bin/bash")
    temp_source_config("{}/clash/configs/config.yaml".format(myclash_root_pwd))





# command = sys.argv[1:]
# print("command = {}".format(command))
# try:
#     result = subprocess.check_output(command, shell = True, executable = "/bin/bash", stderr = subprocess.STDOUT)

# except subprocess.CalledProcessError as cpe:
#     result = cpe.output

# finally:
#     for line in result.splitlines():
#         print(line.decode())