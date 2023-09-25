#!/usr/bin/env python
import sys
import yaml
import getpass
import os
# print ("Number of arguments:", len(sys.argv), "arguments")
# print ("Argument List:", str(sys.argv))
EXEC_DIR = os.getenv('MY_CLASH_BASH_PWD')
print()
# sys.args[1]
with open(EXEC_DIR+'../config.yaml', "r") as stream:
    try:
        dictionary = yaml.safe_load(stream)
        for key, value in dictionary.items():
            if(str(sys.argv[1]) == key):
                # print (key + " : " + str(value))
                print(str(value))
                sys.exit(0)
        
    except yaml.YAMLError as exc:
        print(exc)
sys.exit(1)
