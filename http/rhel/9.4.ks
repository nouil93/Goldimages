text
firstboot --disable
cdrom

lang en_US.UTF-8
network --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network --hostname=redhat9.localdomain
selinux --disabled
rootpw testtest
repo --name="AppStream" --baseurl=file:///run/install/sources/mount-0000-cdrom/AppStream
user --groups=wheel --name=vagrant --password=vagrant --uid=1000 --gecos="user" --gid=1000
sshkey --username=vagrant "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrWNzFq89A+OGFiyXPxU3y+PkOOks65kZYMOMf0cIsymsiH63jAxJM/7XMxKj7xVbyHG88lV1WVJLH1BmqwhzQ/qiUDx0RZh4IYisISiN40exK9mNrZEvTPCXeL563OQbdz1IA+3MFU1ZaELAOUs7mw7qC32HMp2taSW0YqbjqmRHw/CU6ZvuUFvXkLUSPL0ENGaOJZyfxNoE53QvIHdvDRgc04l3C8+GS+eB1aa9EN0ACaLJQMCZMEdgBSR0VVHfTpNiJ4d2FMBHqFNned2vawjvEiVoilwwlBdEQauYYH6JRw++qMif3su56apJdIWowqlTtZW8lyORv8KUvC8Q4EfTLjRA9gR+ELz6guNPJ2/j+QQB6fKbyU6cAMe4Nr3oAZlSkeHWZcrxEmMj7PS580Ry9XeCMK64IRjq8jjPACHYCoYvf0ujvC+FKAkfmttigjbwAihd27+2//Q9bZZh4veX6clSCsIJ6LHD+4cBvzUEpHiZ8mGREoYI16JbzSqkKVTo9AHMzYvlW968jIE6UfKleLCBHqL2Mvnur5wRJm6KrA7skZ4ep8uR+v/cu3hBLlnpQXA9EBBhlvo/efLU3XmkXyaDryua9aipA5hGGeHIFEBc3yeu7JqHvdwDTJL3Zc7qilXTnkwyjMBusX3wJSvsu07FWeJEP3mRsgVwn4w== fred@procyon"
#sshkey --username=user "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUXg2vJmOBNIHd5j6gWFBs0/I4IWXp1jIHBn93FyUQsgiVOG82jhCA69G2SqCYbZHRJSJhwOFSMtMsvDno5Gz+tZMSASliiQnDD26YxiqZZUOApqCpdYKYEhwjVcokjKfm1rVdYhysk1K/qmlL6D0SVAzZxsepl7x8JksMVjvOsuGsZywsvh/Ck7JqEMt9O/NDWv0iFGkGy7J888eAnc+bMyiVV4ND+yYPqpCtL+fPU/dY7+LMR9uDoiJK8fAOmCrBvRLwmKOCh4NNRsHk58L36gl3ArUpNlqWrotpLROHhrXcuh4hSmPuTVsxQOTrzaHM2oVkw/+LBpFFqMLJrAaM8sVrfUBAhRD91cFHjazXg7RvXE1dbkPWDH6THJ71CS1FLyz2htMd7nYuJX/3J2bk533JKZVy/nOEtb0k2s1yCw4WNhT7M+RSFjsvgFsJJkvcGKPpIUwdkctzAXj4hAC1sdhiLsdh/j9E5yw2Tr6rRZ4nuBGDUOqlHABSZBm1d6k= packer-kvm-default-key"
sshkey --username=root "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUXg2vJmOBNIHd5j6gWFBs0/I4IWXp1jIHBn93FyUQsgiVOG82jhCA69G2SqCYbZHRJSJhwOFSMtMsvDno5Gz+tZMSASliiQnDD26YxiqZZUOApqCpdYKYEhwjVcokjKfm1rVdYhysk1K/qmlL6D0SVAzZxsepl7x8JksMVjvOsuGsZywsvh/Ck7JqEMt9O/NDWv0iFGkGy7J888eAnc+bMyiVV4ND+yYPqpCtL+fPU/dY7+LMR9uDoiJK8fAOmCrBvRLwmKOCh4NNRsHk58L36gl3ArUpNlqWrotpLROHhrXcuh4hSmPuTVsxQOTrzaHM2oVkw/+LBpFFqMLJrAaM8sVrfUBAhRD91cFHjazXg7RvXE1dbkPWDH6THJ71CS1FLyz2htMd7nYuJX/3J2bk533JKZVy/nOEtb0k2s1yCw4WNhT7M+RSFjsvgFsJJkvcGKPpIUwdkctzAXj4hAC1sdhiLsdh/j9E5yw2Tr6rRZ4nuBGDUOqlHABSZBm1d6k= packer-kvm-default-key"
timezone America/Denver --utc
bootloader --location=mbr --append=" net.ifnames=0 biosdevname=0 crashkernel=no"
services --disabled="kdump" --enabled="NetworkManager,sshd,rsyslog,chronyd,cloud-init,cloud-init-local,cloud-config,cloud-final,rngd"
# Clear the Master Boot Record
zerombr
# Remove partitions
clearpart --all --initlabel
ignoredisk --only-use=vda
# Automatically create partitions using LVM
autopart --type=lvm

# Reboot after successful installation
reboot

%packages --excludedocs 
sudo
#@guest-agents
qemu-guest-agent
openssh-server
wget
python3
-kexec-tools
-dracut-config-rescue
-plymouth*
-iwl*firmware
%end

%addon com_redhat_kdump --disable
%end

%post
# Update time
#/usr/sbin/ntpdate -bu 0.fr.pool.ntp.org 1.fr.pool.ntp.org

#sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers
sed -i 's/rhgb //' /etc/default/grub

# Disable consistent network device naming
#/usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

# sshd PermitRootLogin yes
#sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
#echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cat <<EOF >> /etc/sudoers
Defaults !requiretty
root ALL=(ALL) ALL
vagrant ALL=(ALL) NOPASSWD: ALL
EOF

#yum install -y http://172.17.0.2/epel-release-latest-9.noarch.rpm


# Enable NetworkManager, sshd and disable firewalld
#/usr/bin/systemctl enable NetworkManager
/usr/bin/systemctl enable sshd
/usr/bin/systemctl start sshd
#/usr/bin/systemctl disable firewalld

# Need for host/guest communication
/usr/bin/systemctl enable qemu-guest-agent
/usr/bin/systemctl start qemu-guest-agent

# Update all packages
#/usr/bin/yum -y update
/usr/bin/yum -y update
/usr/bin/yum -y install perl redhat-lsb-core sudo wget
/usr/bin/yum -y install ansible
/usr/bin/yum -y install epel-release
/usr/bin/yum clean all

# Not really needed since the kernel update already did this. Furthermore,
# running this here reverts the grub menu to the current kernel.
grub2-mkconfig -o /boot/grub2/grub.cfg
%end
