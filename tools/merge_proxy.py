#!/usr/bin/env python3
import sys
import yaml
import getpass
import os


def merge_configs(config_names):
    pass

def merge_config(config_name,root_pwd):
    raw_configs_stream = open(root_pwd+'/sub_configs/{}.yaml'.format(config_name), "r",encoding='utf-8')
    raw_configs = yaml.safe_load(raw_configs_stream)
    custom_configs_stream = open(root_pwd+'/custom_configs/{}.yaml'.format(config_name), "r",encoding='utf-8')
    custom_configs = yaml.safe_load(custom_configs_stream)

    # cover
    cover_configs = ["port" , "socks-port", "mode", "allow-lan", "log-level", "external-controller"]
    # port: 7890
    # socks-port: 7891
    # allow-lan: true
    # mode: Rule
    # log-level: info
    # external-controller: :9090

    for key, value in custom_configs.items():
        if key in cover_configs:
            raw_configs[key] = custom_configs[key]
            # print(key ,raw_configs[key])


    # add
    add_configs = ["proxies" , "proxy-groups", "rules"]

    for key, value in custom_configs.items():
        if key in add_configs:
            # print(type(custom_configs[key]))
            if type(custom_configs[key]) is list: 
                for i in custom_configs[key]:
                    raw_configs[key].insert(0, i)
                    # if(i):

                    # else:
                    #     raw_configs[key].append(i)

    with open(root_pwd+'/clash/configs/{}.yaml'.format(config_name),'w') as yamlfile:
        yaml.safe_dump(raw_configs, yamlfile,allow_unicode=True)
