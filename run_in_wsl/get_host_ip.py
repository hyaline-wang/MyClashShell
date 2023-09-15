import os

ip_str = os.popen("ip address show eth0 |grep \"inet \"")
vnet_ip = ip_str.read().split()[1].split("/")[0]

ip_split_dot = vnet_ip.split(".")
host_ip = []
for id,data in enumerate(ip_split_dot):
    # print(id,data)
    if id == 2 :
        host_ip.append(str(int(data)&0xF0))
    elif id == 3 :
        host_ip.append("1")
    else:
        host_ip.append(data)    
print(host_ip[0]+"."+host_ip[1]+"."+host_ip[2]+"."+host_ip[3])


