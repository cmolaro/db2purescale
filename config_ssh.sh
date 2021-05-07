#!/bin/bash

# ssh settings
while true; do
    read -p "Confige Password-less SSH? (y/n)" yn
    case $yn in
        [Yy]* ) echo "Ok";
                ssh-keygen -t rsa ;
                cp /root/.ssh/id_rsa.pub /root/id_rsa.$(hostname) ;
                echo "Update db2nod1.tmb.com as per your environment";
                scp /root/id_rsa.* root@db2nod1.tmb.com:/root/ ;
                echo "Run in db2nod1.tmb.com";
                for file in /root/id_rsa.*; do cat $file >> /root/.ssh/authorized_keys; done
                echo "Copy to all members:";
                scp /root/.ssh/authorized_keys root@db2nod1.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@db2nod2.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@db2nod3.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@db2nod4.tmb.com:/root/.ssh/ ;
                echo "Validate:";
                ssh db2nod1.tmb.com ;
                ssh db2nod2.tmb.com ;
                ssh db2nod3.tmb.com ;
                ssh db2nod4.tmb.com ;
                break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
