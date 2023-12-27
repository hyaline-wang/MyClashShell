#!/usr/bin/python
import subprocess, sys
import os
import warnings 
import traceback
import yaml
import requests

myclash_root_pwd = os.getenv('MYCLASH_ROOT_PWD') # None
if myclash_root_pwd is None:
    raise TypeError("[ERROR] 找不到 MYCLASH_ROOT_PWD;请尝试 source /etc/bash.bashrc ;source ~/.bashrc 然后重新运行")

print("delete old config")
# print(subprocess.run("rm123 {}/clash/configs/*.yaml".format(myclash_root_pwd), shell = True, executable="/bin/bash").returncode)
print(subprocess.run("rm -rf {}/sub_configs".format(myclash_root_pwd), shell = True, executable="/bin/bash").returncode)
print(subprocess.run("mkdir {}/sub_configs".format(myclash_root_pwd), shell = True, executable="/bin/bash").returncode)

print("download new config")

# read yaml

with open(myclash_root_pwd+'/config_custom.yaml', "r") as stream:
    try:
        dictionary = yaml.safe_load(stream)
        sub_dict = dictionary.get("subscribes")
        if(sub_dict is None):
            raise TypeError("[ERROR] 没有找到订阅信息")
        for key, value in sub_dict.items():
            x = requests.get(value)
            f = open("{}/sub_configs/{}.yaml".format(myclash_root_pwd,key), "w")
            f.write(x.text)
            f.close()           
    except SystemExit:
        pass
    # except :
    #     print("failed")


# merge proxy




# command = sys.argv[1:]
# print("command = {}".format(command))
# try:
#     result = subprocess.check_output(command, shell = True, executable = "/bin/bash", stderr = subprocess.STDOUT)

# except subprocess.CalledProcessError as cpe:
#     result = cpe.output

# finally:
#     for line in result.splitlines():
#         print(line.decode())