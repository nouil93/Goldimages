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
    --machine-readable $vm_name box.img

IMG_SIZE=$(qemu-img info --output=json "box.img" | awk '/virtual-size/{s=int($2)/(1024^3); print (s == int(s)) ? s : int(s)+1 }')
echo -n "image size: {$IMG_SIZE}"
cat > metadata.json <<EOF
{
    "provider": "libvirt",
    "format": "qcow2",
    "virtual_size": ${IMG_SIZE}
}
EOF

hostname=$vmversion \
box=$vm_name \
envsubst < "../data/Vagrantfile" > "Vagrantfile"

tar --create --verbose \
    --sparse --totals \
    ./metadata.json \
    ./Vagrantfile \
    ./box.img \
    | gzip -c > ../build/$vm_name.box

cd ..
rm -rf $tmp_directory