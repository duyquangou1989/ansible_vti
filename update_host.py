#!/usr/bin/python3
import requests
import json
import sys

#1 : Disable
#0 : Enable

status = sys.argv

if len(status) <= 1 or status[1] == "" :
    print ('Input status 0 or 1')
    sys.exit(1)

zabbixAPI = 'http://zabbix.dssvti.com/api_jsonrpc.php'
userzab = 'jenkins'
pwdzab = '2isfVw0Y7BAM'
prelist = ['predl-app-demo','predl-db-demo','predl-elastic-demo']

datalogin = '{"jsonrpc":"2.0","method":"user.login","id":1,"auth":null,"params":{"user":"%s","password": "%s"}}' % (userzab,pwdzab)
login = requests.post(zabbixAPI, datalogin, headers={'Content-Type' : 'application/json-rpc'})
login_dict = json.loads(login.text)
token = login_dict['result']
print('Login ok with token %s' % token) 

hostid_list = []

for host in prelist:
    datagethost = '{"jsonrpc":"2.0","method":"host.get","id":1,"auth":null,"params":{"filter": {"host": ["%s"]}},"auth": "%s"}' % (host,token)
    gethost = requests.post(zabbixAPI, datagethost, headers={'Content-Type' : 'application/json-rpc'})
    gethost_dict = json.loads(gethost.text)
    hostid = gethost_dict['result'][0]['hostid']
    hostid_list.append(hostid)

#Start update host 
for id_host in hostid_list:
    dataupdate = '{"jsonrpc":"2.0","method":"host.update","id":1,"auth":null,"params":{"hostid": "%s", "status": %s},"auth": "%s"}' % (id_host,status[1],token)
    hostupdated =  requests.post(zabbixAPI, dataupdate, headers={'Content-Type' : 'application/json-rpc'})

print('Updated host status success')

datalogout = '{"jsonrpc":"2.0","method":"user.logout","id":1,"auth":null,"params": [], "auth": "%s"}' % (token)
logout = requests.post(zabbixAPI, datalogout, headers={'Content-Type' : 'application/json-rpc'})
print('Logout ok')
