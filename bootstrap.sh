#!/bin/sh

set -x

# Stage 1

setup-hostname nyx
setup-dns 8.8.8.8
setup-apkrepos -c -1
setup-disk -m sys /dev/sda

# Stage 2

TARGET="/mnt"

mount /dev/sda3 "$TARGET"
mount /dev/sda1 "$TARGET/boot"

cp /etc/network/interfaces "$TARGET/etc/network/interfaces"
ln -s /etc/init.d/networking "$TARGET/etc/runlevels/boot/networking"

apk --root "$TARGET" update
apk --root "$TARGET" add vim git make qemu-img qemu-system-x86_64

GITHUB="https://raw.githubusercontent.com"

wget "$GITHUB/vinc/moros/trunk/dsk/ini/palettes/gruvbox-dark.sh" \
  -O "$TARGET/etc/profile.d/palette.sh"
sed -i "s/print/printf/g" "$TARGET/etc/profile.d/palette.sh"
sed -i "s/\\\e\[1A//g" "$TARGET/etc/profile.d/palette.sh"
echo "chvt 2 && chvt 1" >> "$TARGET/etc/profile.d/palette.sh"
sh "$TARGET/etc/profile.d/palette.sh"
cat << EOF > "$TARGET/etc/init.d/consolepalette"
#!/sbin/openrc-run

name="consolepalette"
description="Set console palette"

depend() {
    need root
}

start() {
    sh /etc/profile.d/palette.sh
    return 0
}
EOF
chmod +x "$TARGET/etc/init.d/consolepalette"
ln -s /etc/init.d/consolepalette "$TARGET/etc/runlevels/boot/consolepalette"

mkdir "$TARGET/usr/share/consolefonts"
wget "$GITHUB/vinc/moros/trunk/dsk/ini/fonts/zap-light-8x16.psf" \
  -O "$TARGET/usr/share/consolefonts/zap-light-8x16.psf"
gzip "$TARGET/usr/share/consolefonts/zap-light-8x16.psf"
echo 'consolefont="zap-light-8x16.psf.gz"' > "$TARGET/etc/conf.d/consolefont"
setfont "$TARGET/usr/share/consolefonts/zap-light-8x16.psf.gz"
ln -s /etc/init.d/consolefont "$TARGET/etc/runlevels/boot/consolefont"

cat << EOF > "$TARGET/etc/profile.d/aliases.sh"
alias copy="cp"
alias drop="rm"
alias edit="vim -p"
alias list="ls -lh"
alias move="mv"
alias print="echo"
alias read="cat"
alias view="less"
EOF

cat << EOF > "$TARGET/etc/profile.d/prompt.sh"
PS1="\n\e[0;34m\w\e[m\n\e[0;35m>\e[m "
EOF

echo -e "Welcome to Nyx 0.3.0\n" > "$TARGET/etc/issue"
echo -e "\nHappy hacking!" > "$TARGET/etc/motd"
cat << EOF > "$TARGET/usr/local/bin/login"
#!/bin/sh
cat /etc/issue
printf "Username: "
read username
exec /bin/login "\$username"
EOF
chmod +x "$TARGET/usr/local/bin/login"
sed -i "s/getty 38400/getty -n -l \/usr\/local\/bin\/login 38400/g" \
  "$TARGET/etc/inittab"
sed -i "s/getty -L 0/getty -n -l \/usr\/local\/bin\/login -L 0/g" \
  "$TARGET/etc/inittab"

wget "$GITHUB/vinc/pkg/master/pkg.sh"
mv pkg.sh "$TARGET/usr/local/bin/pkg"
chmod +x "$TARGET/usr/local/bin/pkg"

#git clone https://github.com/vinc/moros
#cd moros
#make setup
#make image output=serial keyboard=dvorak
#make qemu output=serial nic=rtl8139
