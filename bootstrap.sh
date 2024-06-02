#!/bin/bash

setup-hostname nyx
setup-interfaces -ar
setup-apkrepos -c -1
#setup-disk -m sys /dev/sda

setup-keymap us us-dvorak

MOROS="https://raw.githubusercontent.com/vinc/moros/trunk"

wget "$MOROS/dsk/ini/palettes/gruvbox-dark.sh" -O palette.sh
sed -i "s/print/echo -ne/g" palette.sh
sed -i "s/\\\e\[1A//g" palette.sh
bash palette.sh

wget "$MOROS/dsk/ini/fonts/zap-light-8x16.psf" -O font.psf
setfont font.psf

cat << EOF > /etc/profile.d/aliases.sh
alias copy="cp"
alias edit="vim -p"
alias list="ls -lh"
alias move="mv"
alias read="cat"
alias view="less"
EOF

cat << EOF > /etc/profile.d/prompt.sh
PS1="\n\e[0;34m\w\e[m\n\e[0;35m>\e[m "
EOF

echo -e "Welcome to Nyx v0.2.0\n" > /etc/motd
echo -e "\nHappy hacking!" > /etc/motd
cat << EOF > /usr/local/bin/hello
#!/bin/sh
cat /etc/issue
printf "Username: "
read username
exec /bin/login "$username"
EOF
chmod a+x /usr/local/bin/hello
sed -i "s/getty 38400/getty -n -l \/usr\/local\/bin\/login 38400/g" /etc/inittab
sed -i "s/getty -L 0/getty -n -l \/usr\/local\/bin\/login -L 0/g" /etc/inittab

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
