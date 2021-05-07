#!/bin/bash

# in all nodes:

ssh-keygen -t rsa
# (press enter for all questions)
cp /root/.ssh/id_rsa.pub /root/id_rsa.pub.$(hostname)


# in all nodes, consolidate pub keys to db2node1
scp /root/id_rsa.pub.* root@dbnod1:/root/

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
                scp /root/.ssh/authorized_keys root@dbnod1.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@dbnod2.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@dbnod3.tmb.com:/root/.ssh/ ;
                scp /root/.ssh/authorized_keys root@cfnod1.tmb.com:/root/.ssh/ ;
                echo "Validate:";
                ssh dbnod1.tmb.com ;
                ssh dbnod2.tmb.com ;
                ssh dbnod3.tmb.com ;
                ssh cfnod1.tmb.com ;
                break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
