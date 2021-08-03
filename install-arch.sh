#!/bin/sh

set -e

INSTALL_PATH="/mnt"
UEFI=1
ESP_DIRECTORY="/boot"
ROOT_PARTITION="/dev/nvme0n1p3"
TIME_ZONE="Europe/Stockholm"
LOCALE="en_US.UTF-8"
KEYMAP="sv-latin1"
NEW_HOSTNAME="Pluto"

BASE_PACKAGES="base base-devel linux linux-firmware"

# Make sure we are connected to the internet
if [ "$(ping -c 1 archlinux.org)" -ne 1 ]
then
    echo "You must connect to the internet before installing."
    echo "See the iwctl program for WiFi."
    exit 1
fi

# Install the base system
pacstrap "$INSTALL_PATH" $BASE_PACKAGES

# Generate /etc/fstab
genfstab -U "$INSTALL_PATH" >> "${INSTALL_PATH}/etc/fstab"

# Copy chroot script
cp ./chroot.sh "${INSTALL_PATH}/tmp"

# Setup system in chroot
arch-chroot /mnt /usr/bin/env -i UEFI="$UEFI" ESP_DIRECTORY="$ESP_DIRECTORY" ROOT_PARTITION="$ROOT_PARTITION" TIME_ZONE="$TIME_ZONE" LOCALE="$LOCALE" KEYMAP="$KEYMAP" NEW_HOSTNAME="$NEW_HOSTNAME" /tmp/chroot.sh

# Unmount
umount -R "$INSTALL_PATH"
