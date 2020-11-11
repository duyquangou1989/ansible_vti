#!/bin/bash

addonpath='/data/dl-addons13'
dataenpath='/data/odoo13/'$(ls -t /data/odoo13| head -n1)

rm -rf ${addonpath}/*

rm -rf ${dataenpath}/*

deploy()
{
    echo "Rsync jenkins $1 Addons ..."
    cd /root/jenkins_$1/add-ons; rsync -avz -r * ${addonpath}/
    [[ $? -ne 0 ]] && exit 1
    echo "Rsync jenkins $1 Enterprise Source ..."
    cd /root/jenkins_$1/odoo-13.0e; rsync -avz -r * ${dataenpath}/
    [[ $? -ne 0 ]] && exit 1
}

#rm done  ?
#begin rsync 

if [ -z $1 ];
then
    echo 'Staging or Master ?'
    exit 1
fi

if [ $1 == 'master' ] || [ $1 == 'staging' ]
then
    deploy $1
else
    echo 'Staging or Master ?'
    exit 1
fi

chmod 777 -R /data

#Restart Odoo
systemctl restart odoo