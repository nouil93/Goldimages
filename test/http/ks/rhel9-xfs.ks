#version=RHEL9
install
lang en_US.UTF-8
keyboard us
timezone UTC --isUtc
rootpw redhat
reboot
network --bootproto=dhcp --device=eth0 --activate
bootloader --location=mbr --boot-drive=sda --efi
clearpart --all --initlabel
reqpart --add-boot
part /boot/efi --fstype=efi --size=200
part /boot --fstype=xfs --size=1024
part / --fstype=xfs --size=10240 --grow --asprimary
%packages
@core
%end
%post
echo "Built with XFS profile" > /etc/image-profile
%end
