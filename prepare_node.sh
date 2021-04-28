#!/bin/bash
# prepare a cloned VM to be used in a db2 pureScale cluster

# Resets the RSCT node ID
/opt/rsct/install/bin/recfgct -F

while true; do
    read -p "Update /etc/hostname done? [update /etc/hostname] (y/n)" yn
    case $yn in
        [Yy]* ) echo "Ok"; break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Update /etc/hosts done? Add all clusters (y/n)" yn
    case $yn in
        [Yy]* ) echo "Ok"; break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ssh settings
while true; do
    read -p "Confige Password-less SSH? (y/n)" yn
    case $yn in
        [Yy]* ) echo "Ok";
                ssh-keygen -t rsa ;
                cp /root/.ssh/id_rsa.pub /root/id_rsa.$(hostname) ;
                echo "Update vm1.tmb.com as per your environment";
                scp /root/id_rsa.* root@vm1.tmb.com:/root/ ;
                echo "Run in vm1.tmb.com";
                for file in /root/id_rsa.*; do cat $file >> /root/.ssh/authorized_keys; done
                echo "Copy to all members:";
                scp /root/.ssh/authorized_keys root@vm1.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@vm2.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@vm3.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@vm4.tmb.com:/root/.ssh/ ;
                echo "Validate:";
                ssh vm1.tmb.com ;
                ssh vm2.tmb.com ;
                ssh vm3.tmb.com ;
                ssh vm4.tmb.com ;
                break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

