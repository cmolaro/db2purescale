#!/bin/bash
# Update .bash_profile

# -----------------------------------------------
# .bash_profile
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
# User specific environment and startup programs
PATH=$PATH:$HOME/bin
export PATH

export DISPLAY=192.168.1.108:0.0 # update
mount /dev/cdrom /cdrom

git config --global user.name "Toto" # update
git config --global user.email "toto@gmail.com" # update
# -----------------------------------------------

# cdrom repository: using the RHEL DVD as package repository
mkdir /cdrom
mount /dev/cdrom /cdrom
rpm --import /cdrom/RPM-GPG-KEY-redhat-release

cp -rp /etc/yum.repos.d /etc/yum.repos.d.backup
# pseudo code
cat > /etc/yum.repos.d/local.repo <<END \
[cdrom]
name=CDROM Repo
baseurl=file:///cdrom
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
END

# general
mkdir /work
chmod 777 /work

#git
yum -y install git
cd /work
git clone https://github.com/cmolaro/db2purescale

#get software
mkdir /work/db2install
chmod 777 /work/db2install

#----------------------------------------------------
# move db2 installers to /work/db2install/db211.5.5.1
#----------------------------------------------------

#packages needed for db2 11.5.5.1 in RHEL 7.7
/work/db2install/db211.5.5.1/db2prereqcheck | less 

yum install libstdc++.i686 # 32-bit library file: "libstdc++.so.6"
yum install pam.i686 # 32-bit library file: "/lib/libpam.so*"
yum install m4 # m4
yum install gcc # DBT3507E  The db2prereqcheck utility failed to find the following package or file: "gcc"
yum install cpp # DBT3507E  The db2prereqcheck utility failed to find the following package or file: "cpp"
yum install gcc-c++ # DBT3507E  The db2prereqcheck utility failed to find the following package or file: "gcc-c++"
yum install kernel-devel # DBT3507E  The db2prereqcheck utility failed to find the following package or file: "kernel-devel"
yum install patch # DBT3507E  The db2prereqcheck utility failed to find the following package or file: "patch"
yum install ksh # Required minimum version for "ksh": "20100621" - WARNING : Requirement not matched
yum install ntpd # Required minimum version for "ntpd": "4.2.6p5" - WARNING : Requirement not matched
yum install libXext # Fixes: (libXext.so.6: cannot open shared object file: No such file or directory)
yum install libXrender # Fixes: (libXrender.so.1: cannot open shared object file: No such file or directory)
yum install libXtst # Fixes: (libXtst.so.6: cannot open shared object file: No such file or directory)
yum install libXft # Fixes: (libXft.so.2: cannot open shared object file: No such file or directory)

# Fix for:
# DBT3563E  The db2prereqcheck utility determined that SELinux is enabled, which is not supported with GPFS
# Edit /etc/selinux/config to SELINUX=disabled; reboot


