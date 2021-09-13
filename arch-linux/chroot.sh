#!/bin/sh

set -e

# Timezone
ln -sf "/usr/share/zoneinfo/${TIME_ZONE}" /etc/localtime
hwclock --systohc

# Localization
echo "LANG=${LOCALE}" > /etc/locale.conf
locale-gen
echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf

# Hostname
echo "$_HOSTNAME" > /etc/hostname
echo "\
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${_HOSTNAME}.localdomain ${_HOSTNAME}
" >> /etc/hosts

# Users and passwords
echo "Enter a password for the root user:"
passwd
while true
do
    echo "Enter a username to create a user (leave blank for no user):"
    read -r USERNAME

    if [ "$USERNAME" = "" ]
    then
        break
    fi

    echo "Should this user be a member of the wheel group? (y/N)"
    read -r WHEEL

    if [ "$WHEEL" = "y" ] || [ "$WHEEL" = "Y" ]
    then
        useradd -m -G wheel "$USERNAME"
    else
        useradd -m "$USERNAME"
    fi

    echo "Enter a password for the new user:"
    passwd "$USERNAME"
done

# Install bootloader
if [ "$UEFI" = true ]
then
    bootctl install

    echo "\
default arch.conf
timeout 3
console-mode max
editor no
" >> "${ESP_DIR}/loader/loader.conf"

    echo "\
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=$(blkid "$ROOT_DIR" | sed s/\"//g | cut -d' ' -f2) rw
" >> "${ESP_DIR}/loader/entries/arch.conf"

    bootctl update
else
    grub-install --target=i386-pc "$DISK"
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# Install additional packages
pacman -S --noconfirm $ADDITIONAL_PKGS

# Enable services
# shellcheck disable=SC2153
for SERVICE in $SERVICES
do
    systemctl enable "$SERVICE"
done
