#!/bin/bash

set -e
set -x

cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base
baseurl=http://mirror.centos.org/centos/7/os/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=http://mirror.centos.org/centos/7/updates/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=http://mirror.centos.org/centos/7/extras/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://mirror.centos.org/centos/7/centosplus/x86_64/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

cat <<EOF > /etc/yum.repos.d/epel.repo
[epel]
baseurl = https://dl.fedoraproject.org/pub/epel/7/x86_64/
gpgcheck = 1
gpgkey = https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
name = EPEL YUM repo
EOF

yum install -y \
  https://github.com/OpenNebula/addon-context-linux/releases/download/v5.8.0/one-context-5.8.0-1.el7.noarch.rpm