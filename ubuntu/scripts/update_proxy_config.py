#!/usr/bin/python
import subprocess, sys
import os
import warnings 
import traceback
import yaml
import util
import logging
import colorlog

def download_profile(profile_name:str,url:str):
    '''
    下载profile
    '''
    full_url = f"{url}&flag=clash"

    logger.info(f'{profile_name} : "{full_url}"')

    tmp_cfg_save_path = raw_configs_dir+f"/{profile_name}.yaml"
    download_configs_cmd= f'unset http_proxy https_proxy;curl -o {tmp_cfg_save_path} -k  --max-time 20 "{full_url}"'
    # -k 取消校验
    # --max-time 10 设置超时
    print(download_configs_cmd)
    result = subprocess.run(download_configs_cmd, shell=True, capture_output=True, text=True)
    # print(result.returncode)
    if result.returncode != 0:
        logger.debug(result.stdout.strip())
        logger.error(f"Download {profile_name} failed")
        print(result.stdout.strip())
        return False

    #  asset config is already download
    result = subprocess.run("find "+tmp_cfg_save_path, shell=True, capture_output=True, text=True)
    if result.returncode == 0:
        # print(result.stdout.strip())
        logger.info(f"Download {profile_name} success")
        return True
        # Get the size of the file in bytes
        # file_size = os.path.getsize(tmp_cfg_save_path)
        # print(f"The size of the file is: {file_size} bytes")
    else:
        logger.error(f"Download {profile_name} failed")
        return False

    
if __name__=="__main__":

    # find path
    myclash_root_pwd = os.getenv('MYCLASH_ROOT_PWD') # None
    if myclash_root_pwd is None:
        raise TypeError("[ERROR] 找不到 MYCLASH_ROOT_PWD;请尝试 source /etc/bash.bashrc ;source ~/.bashrc 然后重新运行")
    raw_configs_dir = "{}/tmp".format(myclash_root_pwd)
    custom_cfgs_dir = "{}/custom_configs".format(myclash_root_pwd)
    gen_rule_cfg_pwd = "{}/clash/configs/config.yaml".format(myclash_root_pwd)
    user_config_path = myclash_root_pwd+'/user_config.yaml'

    # 创建日志记录器
    logger = logging.getLogger("MCS:Update Profile")
    logger.setLevel(logging.INFO)
    # 创建一个控制台输出处理器，并且配置颜色
    console_handler = logging.StreamHandler()

    # 配置日志格式和颜色
    formatter = colorlog.ColoredFormatter(
        '%(log_color)s%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        log_colors={
            'DEBUG': 'blue',
            'INFO': 'green',
            'WARNING': 'yellow',
            'ERROR': 'red',
            'CRITICAL': 'bold_red',
        }
    )

    console_handler.setFormatter(formatter)

    # 创建文件处理器
    file_handler = logging.FileHandler(myclash_root_pwd+'/app.log')
    file_handler.setFormatter(formatter)

    # 将处理器添加到记录器
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)


    # logger.info("1. Delete Download Configs")
    # subprocess.run("rm -rf {}".format(raw_configs_dir), shell = True, executable="/bin/bash")
    # subprocess.run("mkdir {}".format(raw_configs_dir), shell = True, executable="/bin/bash")
    # print(subprocess.run("rm -rf {}".format(raw_configs_dir), shell = True, executable="/bin/bash").returncode)
    # print(subprocess.run("mkdir {}".format(raw_configs_dir), shell = True, executable="/bin/bash").returncode)
    # print("download new raw_config")

    # read yaml and find avilable cfg
    download_configs = []
    default_subcribe = None
    with open(user_config_path, "r") as stream:
        try:
            dictionary = yaml.safe_load(stream)
            default_subcribe = dictionary.get("default_subscribe")
            sub_dict = dictionary.get("subscribes")
            if(sub_dict is None):
                raise TypeError("[ERROR] 没有找到订阅信息")
            logger.info("====Update Config====")
            for key, value in sub_dict.items():
                if(util.is_valid_url(value)):
                    ret = download_profile(key,value)
                    if ret:
                        download_configs.append(key)
                else:
                    logger.error(f"invalid param {key}:{value}")
                    exit()

        except SystemExit:
            pass

    # merge custom config
    if(len(download_configs) > 0):
        logger.info("====Gen Clash Config====")
        # subprocess.run("rm -rf {}".format(gen_rule_cfg_pwd), shell = True, executable="/bin/bash")
        # subprocess.run("mkdir {}".format(gen_rule_cfg_pwd), shell = True, executable="/bin/bash")

        import merge_proxy
        custum_proxy_path = myclash_root_pwd + "/custom_configs"
        for i in download_configs:
            logger.info("merge {} configs".format(i))

            merge_proxy.merge_cfg(
                raw_rule_path=f"{raw_configs_dir}/{i}.yaml",
                custum_rule_path=f"{custum_proxy_path}/{i}.yaml",
                gen_cfg_path=gen_rule_cfg_pwd
            )
            
        if (default_subcribe in download_configs):
            logger.info("代理更新完成: 使用: {}".format(default_subcribe))
            util.update_config_by_api(gen_rule_cfg_pwd)
        else:
            logger.info("代理更新完成: 未找到指定profile，代理使用: {}".format(download_configs[0]))
            util.update_config_by_api(gen_rule_cfg_pwd)
    else:
        if(len(download_configs) == 0):
            logger.error("没有找到任何可用的代理")
            exit()