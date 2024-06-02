# Nyx

Nyx is the [bedrock platform][0] to build [MOROS][1], a hobby operating system
written in Rust by [Vincent Ollivier][2].

[0]: https://permacomputing.net/bedrock_platform/
[1]: http://moros.cc
[2]: https://vinc.cc

## Setup

Download Alpine Linux base image:

    $ wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.0-x86_64.iso

Run the image with QEMU:

    $ wget https://raw.githubusercontent.com/vinc/nyx/main/qemu.sh
    $ bash qemu.sh

Log in as root inside QEMU then run the following commands:

    # setup-interfaces -ar
    # wget https://raw.githubusercontent.com/vinc/nyx/main/bootstrap.sh
    # bash bootstrap.sh
