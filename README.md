# Nyx

Nyx is the [bedrock platform][0] to build [MOROS][1], a hobby operating system
written in Rust by [Vincent Ollivier][2].

[0]: https://permacomputing.net/bedrock_platform/
[1]: http://moros.cc
[2]: https://vinc.cc

## Setup

Download Alpine Linux base image:

```sh
export url=https://dl-cdn.alpinelinux.org/alpine
export iso=$url/v3.22/releases/x86_64/alpine-virt-3.22.1-x86_64.iso
wget $iso
wget $iso.sha256
sha256sum -c alpine-*.iso.sha256
```

Run the image with QEMU:

```sh
wget https://raw.githubusercontent.com/vinc/nyx/main/qemu.sh
sh qemu.sh alpine-*.iso
```

Log in as `root` inside QEMU then run the following commands:

```sh
setup-keymap us us-dvorak
setup-interfaces -ar
wget https://raw.githubusercontent.com/vinc/nyx/main/bootstrap.sh
sh bootstrap.sh
reboot
```
