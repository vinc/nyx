#!/bin/bash

test -e nyx.img || qemu-img create -f qcow2 nyx.img 8G

qemu-system-x86_64 -name "Nyx 0.3.0" -m 2048 \
  -vga virtio \
  -hda nyx.img -cdrom $1
#  -cpu host -enable-kvm \
#  -display gtk,full-screen=on,show-menubar=off -vga virtio \
#  -display none -chardev stdio,id=s0,signal=off -serial chardev:s0 \
