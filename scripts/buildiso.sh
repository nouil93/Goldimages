#!/bin/bash

set -e
set -x

input='rhel-9.4-x86_64-dvd.iso'
output='rhel-9.4-x86_64-dvd-custom.iso'

# test ! -d iso && mkdir iso || \
#       (echo "iso already created..." && exit -1)

# tmpdir=$(mktemp -d)
# echo $tmpdir
# fuseiso $input iso
# cp --preserve=mode,ownership,timestamps \
#    --recursive \
#    --force \
#    iso $tmpdir
sudo mount -o loop $input iso
tar cf - -C iso | tar xf - -C $tmpdir
# chmod --recursive 775 $tmpdir
# sudo cp cdrom/grub.cfg $tmpdir/iso/EFI/BOOT/grub.cfg
# sudo cp http/rhel/9.4.ks $tmpdir/iso/ks.cfg
# chmod --recursive 775 $tmpdir

tmpdir=/tmp/tmp.9ehYTk6qNs/

mkisofs \
      -o build/$output \
      -V 'RHEL-9.4 Server.x86_64' \
      -b isolinux/isolinux.bin \
      -R -J -l -c isolinux/boot.cat \
      -e images/efiboot.img \
      -no-emul-boot \
      -boot-load-size 4 \
      -boot-info-table \
      -eltorito-alt-boot \
      -graft-points \
      -joliet-long  \
      -allow-limited-size \
      $tmpdir/iso

#-input-charset utf-8 \
# mkisofs -o /tmp/rhel79test.iso -b isolinux/isolinux.bin -J -R -l -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -graft-points -joliet-long -V "RHEL-7.9 Server.x86_64" .
# # isohybrid --uefi /tmp/rhel79test.iso
# # implantisomd5 /tmp/rhel79test.iso

# #rm -rf $tmpdir
echo $tmpdir
#fusermount -u iso && rm -rf iso
