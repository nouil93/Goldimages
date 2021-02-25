#!/bin/bash

set -e

input='soclelinux-2016-0.14.iso'
output='soclelinux-2016.0.14-custom.iso'

test ! -d iso && mkdir iso || \
	echo "iso already created..." && \
      exit -1
tmpdir=$(mktemp -d)
fuseiso $input iso
cp --preserve=mode,ownership,timestamps \
   --recursive \
   --force \
   iso $tmpdir

chmod --recursive 775 $tmpdir
patch $tmpdir/iso/isolinux/isolinux.cfg < scripts/patch

for kickstart in $tmpdir/iso/isolinux/kickstarts/*.cfg
do
  [[ -e "$kickstart" ]] || break
  sed -i 's/\(^network\)/#\ \1/' $kickstart
  sed -i '/# network/a network --hostname=master2016 --device=eth0 --bootproto=dhcp --noipv6' \
     $kickstart
done

mkisofs \
      -o $output \
      -V 'soclelinux-2016-0.14' \
      -b isolinux/isolinux.bin \
      -c isolinux/boot.cat \
      -input-charset utf-8 \
      -no-emul-boot \
      -boot-load-size 4 \
      -boot-info-table \
      -eltorito-alt-boot \
      -e images/efiboot_DGFiP.img \
      -no-emul-boot \
      -R \
      -J \
      $tmpdir/iso

rm -rf $tmpdir
fusermount -u iso && rm -rf iso
