qemu-system-x86_64 -m 2048 -cpu host -enable-kvm \
  -hda nyx.qcow2 \
  -cdrom alpine-virt-3.19.0-x86_64.iso \
  -display none -chardev stdio,id=s0,signal=off -serial chardev:s0
# -display gtk,full-screen=on,show-menubar=off -vga virtio
