#!/bin/bash

set -e
set -x

echo -n "Post Processor Vagrant for ${vm_name}"
tmp_directory="build/"
test ! -d $tmp_directory && mkdir $tmp_directory

cd $tmp_directory/$vm_name
echo -n 'virt-sysprep...'
sudo /usr/bin/virt-sysprep --operations defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids --add $vm_name
sudo /usr/bin/virt-customize --uninstall ansible --add $vm_name
echo -n 'virt-sparsify...'

sudo /usr/bin/virt-sparsify \
    --tmp /home/fred/myProjects/tmp \
    --compress \
    --machine-readable \
    $vm_name $vm_name.qcow2



