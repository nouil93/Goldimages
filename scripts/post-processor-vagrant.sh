#!/bin/bash

set -euo pipefail
set -x

echo -n "Post Processor Vagrant for ${vm_name}"

tmp_directory="build/"
[[ ! -d $tmp_directory ]] && mkdir -p "$tmp_directory"

cd $tmp_directory/$vm_name

# Clean SSH keys, not user dirs
echo -n 'virt-sysprep...'
sudo /usr/bin/virt-sysprep --operations defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids --add $vm_name

# sudo /usr/bin/virt-customize --uninstall ansible --add $vm_name
echo -n 'virt-sparsify...'

sudo /usr/bin/virt-sparsify \
    --compress \
    --machine-readable \
    $vm_name box.img

img_size=$(qemu-img info --output=json "box.img" | awk '/virtual-size/{s=int($2)/(1024^3); print (s == int(s)) ? s : int(s)+1 }')
echo -n "image size: {$img_size}"
cat > metadata.json <<EOF
{
    "provider": "libvirt",
    "format": "qcow2",
    "virtual_size": ${img_size}
}
EOF

export hostname=$vm_name
export box=$vm_name
envsubst < "../../data/Vagrantfile" > "Vagrantfile"

tar --create --verbose \
    --sparse --totals \
    ./metadata.json \
    ./Vagrantfile \
    ./box.img \
    | gzip -c > ../$vm_name.box

cd ..
