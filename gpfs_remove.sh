#!/bin/bash
# gpfs remove from node
# RHEL - 28/04/2021

# reference:
# Steps to permanently uninstall GPFS
# https://www.ibm.com/docs/en/spectrum-scale/5.0.5?topic=installing-steps-permanently-uninstall-gpfs

echo "=============================";
echo "********** WARNING **********";
echo "=============================";


/usr/lpp/mmfs/bin/mmdelnode -f

while true; do
    read -p "Remove node from GPFS cluster? (y/n)" yn
    case $yn in
        [Yy]* ) /usr/lpp/mmfs/bin/mmdelnode -f; break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


while true; do
    read -p "The next steps will permanently uninstall GPFS. Are you sure? (y/n)" yn
    case $yn in
        [Yy]* ) echo "Ok"; break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Unmount all GPFS file systemss? (y/n)" yn
    case $yn in
        [Yy]* ) /usr/lpp/mmfs/bin/mmumount all -a; break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Display the current information for the NSDs belonging to the GPFS cluster"
/usr/lpp/mmfs/bin/mmlsnsd

echo "Delete file systems"
/usr/lpp/mmfs/bin/mmdelfs db2fs1

echo "Remove the NSD volume ID from the device"




while true; do
    read -p "Shutdown GPFS on all nodes? (y/n)" yn
    case $yn in
        [Yy]* ) /usr/lpp/mmfs/bin/mmshutdown -a; break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Uninstall GPFS? (y/n)" yn
    case $yn in
        [Yy]* ) rpm -e gpfs.license.da-5.0.5-0.x86_64; 
                rpm -e gpfs.msg.en_US-5.0.5-0.6.noarch; 
                rpm -e gpfs.gskit-8.0.55-12.x86_64; 
                rpm -e gpfs.gpl-5.0.5-0.6.noarch; 
                rpm -e gpfs.docs-5.0.5-0.6.noarch; 
                rpm -e gpfs.base-5.0.5-0.6.x86_64; 
                break;;
        [Nn]* ) echo "Bye now."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Verify all GPFS packages are gone (Result should be empty)"
rpm -qa gpfs.*
