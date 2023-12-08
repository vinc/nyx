#!/bin/bash

setup-hostname nyx
setup-interfaces -ar
setup-apkrepos -c -1
#setup-disk -m sys /dev/sda

# BEGIN VGA

setup-keymap us us-dvorak

wget https://github.com/vinc/moros/raw/trunk/dsk/ini/fonts/zap-light-8x16.psf
setfont zap-light-8x16.psf

echo -ne "\e]P0282828" # Black
echo -ne "\e]P1CC241D" # Red
echo -ne "\e]P298971A" # Green
echo -ne "\e]P3D79921" # Brown (Dark Yellow)
echo -ne "\e]P4458588" # Blue
echo -ne "\e]P5B16286" # Magenta
echo -ne "\e]P6689D6A" # Cyan
echo -ne "\e]P7EBDBB2" # Light Gray
echo -ne "\e]P8A89984" # Dark Gray (Gray)
echo -ne "\e]P9FB4934" # Light Red
echo -ne "\e]PAB8BB26" # Light Green
echo -ne "\e]PBFABD2F" # Yellow (Light Yellow)
echo -ne "\e]PC83a598" # Light Blue
echo -ne "\e]PDD3869B" # Pink (Light Magenta)
echo -ne "\e]PE8EC07C" # Light Cyan
echo -ne "\e]PFFBF1C7" # White
clear

# END VGA

cat << EOF > /etc/profile.d/aliases.sh
alias list="ls -lh"
alias edit="vim -p"
alias read="cat"
alias copy="cp"
alias move="mv"
EOF

cat << EOF > /etc/profile.d/prompt.sh
PS1="\n\e[0;34m\w\e[m\n\e[0;35m>\e[m "
EOF

echo -e "\nHappy hacking!" > /etc/motd

apk update
apk add curl bash
#apk add vim
#apk add git make qemu-img qemu-system-x86_64

#wget https://raw.githubusercontent.com/vinc/pkg/master/pkg.sh
#mv pkg.sh /usr/local/bin/pkg
#chmod a+x /usr/local/bin/pkg

#git clone https://github.com/vinc/moros
#cd moros
#make setup
#make image output=serial keyboard=dvorak
#make qemu output=serial nic=rtl8139
