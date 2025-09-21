#!/bin/sh

# Stage 1

setup-hostname nyx
setup-apkrepos -c -1
setup-disk -m sys /dev/sda

# Stage 2

TARGET="/mnt"

mount /dev/sda3 "$TARGET"
mount /dev/sda1 "$TARGET/boot"
apk --root "$TARGET" update
apk --root "$TARGET" add vim git make qemu-img qemu-system-x86_64

MOROS="https://raw.githubusercontent.com/vinc/moros/trunk"

wget "$MOROS/dsk/ini/palettes/gruvbox-dark.sh" \
  -O "$TARGET/etc/profile.d/palette.sh"
sed -i "s/print/echo -ne/g" "$TARGET/etc/profile.d/palette.sh"
sed -i "s/\\\e\[1A//g"  "$TARGET/etc/profile.d/palette.sh"
sh "$TARGET/etc/profile.d/palette.sh"

mkdir "$TARGET/usr/share/consolefonts"
wget "$MOROS/dsk/ini/fonts/zap-light-8x16.psf" \
  -O "$TARGET/usr/share/consolefonts/zap-light-8x16.psf"
echo 'consolefont="zap-light-8x16"' > "$TARGET/etc/conf.d/consolefont"
setfont "$TARGET/usr/share/consolefonts/zap-light-8x16.psf"

cat << EOF > "$TARGET/etc/profile.d/aliases.sh"
alias copy="cp"
alias edit="vim -p"
alias list="ls -lh"
alias move="mv"
alias read="cat"
alias view="less"
EOF

cat << EOF > "$TARGET/etc/profile.d/prompt.sh"
PS1="\n\e[0;34m\w\e[m\n\e[0;35m>\e[m "
EOF

echo -e "Welcome to Nyx v0.3.0\n" > "$TARGET/etc/motd"
echo -e "\nHappy hacking!" >> "$TARGET/etc/motd"
cat << EOF > "$TARGET/usr/local/bin/login"
#!/bin/sh
cat /etc/issue
printf "Username: "
read username
exec /bin/login "$username"
EOF
chmod a+x "$TARGET/usr/local/bin/login"
sed -i "s/getty 38400/getty -n -l \/usr\/local\/bin\/login 38400/g" \
  "$TARGET/etc/inittab"
sed -i "s/getty -L 0/getty -n -l \/usr\/local\/bin\/login -L 0/g" \
  "$TARGET/etc/inittab"

#wget https://raw.githubusercontent.com/vinc/pkg/master/pkg.sh
#mv pkg.sh /usr/local/bin/pkg
#chmod a+x /usr/local/bin/pkg

#git clone https://github.com/vinc/moros
#cd moros
#make setup
#make image output=serial keyboard=dvorak
#make qemu output=serial nic=rtl8139
