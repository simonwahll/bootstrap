#!/bin/sh

set -e

. ./config.sh

UEFI=false

# Check if we are booted in UEFI or BIOS mode
if [ -d "/sys/firmware/efi/efivars" ]
then
    UEFI=true
else
    ADDITIONAL_PACKAGES="$ADDITIONAL_PACKAGES grub os-prober"
fi

# Make sure we are connected to the internet
if [ "$(ping -c 1 archlinux.org)" -ne 1 ]
then
    echo "You must connect to the internet before installing."
    echo "See the iwctl program for WiFi."
    exit 1
fi

# Install the base system
# shellcheck disable=SC2086
pacstrap "$ROOT_DIR" $BASE_PACKAGES $ADDITIONAL_PACKAGES

# Generate /etc/fstab
genfstab -U "$ROOT_DIR" >> "${ROOT_DIR}/etc/fstab"

# Copy chroot script
cp ./chroot.sh "$ROOT_DIR"

# Setup system in chroot
arch-chroot /mnt /usr/bin/env -i UEFI="$UEFI" ESP_DIR="$ESP_DIR" ROOT_PART="$ROOT_PART" DISK="$DISK" TIME_ZONE="$TIME_ZONE" LOCALE="$LOCALE" KEYMAP="$KEYMAP" _HOSTNAME="$_HOSTNAME" ADDITIONAL_PACKAGES="$ADDITIONAL_PACKAGES" SERVICES="$SERVICES" /chroot.sh

# Unmount
umount -R "$ROOT_DIR"
