#!/usr/bin/env python
# don't use print debug
import sys
import yaml
import getpass
import os
# print ("Number of arguments:", len(sys.argv), "arguments")
# print ("Argument List:", str(sys.argv))
EXEC_DIR = os.getenv('MYCLASH_ROOT_PWD')
# print(EXEC_DIR)
# sys.args[1]
with open(EXEC_DIR+'/config_custom.yaml', "r") as stream:
    try:
        if(len(sys.argv) == 2 ):
            dictionary = yaml.safe_load(stream)
            for key, value in dictionary.items():
                if(str(sys.argv[1]) == key):
                    # print (key + " : " + str(value))
                    print(str(value))
                    sys.exit(0)
        if(len(sys.argv) == 3 ):
            # print("3 argv")
            dictionary = yaml.safe_load(stream)
            for key, value in dictionary.items():
                if(str(sys.argv[1]) == key):
                    # print (key + " : " + str(value))
                    print(str(value[int(sys.argv[2])]))
                    sys.exit(0)
            
    except yaml.YAMLError as exc:
        print(exc)
sys.exit(1)
