#!/bin/bash
# packages to install

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
