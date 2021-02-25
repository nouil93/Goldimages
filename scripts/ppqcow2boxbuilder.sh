#!/bin/bash

set -e
set -x

vmversion=$(echo ${vm_name} | cut -d "-" -f1)
tmp_directory="goldimage"

cd $tmp_directory

echo -n 'virt-sysprep...'
sudo /usr/bin/virt-sysprep --operations defaults,-ssh-userdir,-ssh-hostkeys --add $vm_name
echo -n 'virt-sparsify...'
sudo /usr/bin/virt-sparsify \
    --compress \
    --machine-readable $vm_name ../build/$vm_name.qcow2

cd ..
rm -rf $tmp_directory