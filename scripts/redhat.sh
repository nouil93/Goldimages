#!/bin/bash

cat << EOF > /etc/yum.repos.d/base.repo
[baseos]
name=Redhat $releasever - BaseOS
baseurl=http://172.17.0.2/BaseOS
enabled=1
gpgcheck=1
countme=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
metadata_expire=86400
enabled_metadata=1
EOF

cat << EOF > /etc/yum.repos.d/appstream.repo
[appstream]
name=Redhat $releasever - AppStream
baseurl=http://172.17.0.2/AppStream
enabled=1
gpgcheck=1
countme=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
metadata_expire=86400
enabled_metadata=1
EOF

yum install -y python3

URL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
wget $URL
rpm -K $(basename $URL)
rpm -ivh $(basename $URL)
rm -f $(basename $URL)
yum -y --nobest install ansible