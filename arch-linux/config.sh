#!/bin/sh

# The directory where the installer should install to.
ROOT_DIR="/mnt"

# Only applicable if you have a UEFI system. This is relative ROOT_DIR.
ESP_DIR="/boot"

# The root partition. Used when installing a bootloader.
ROOT_PART="/dev/nvme0n1p3"

# The disk the system is installed to. Used when installing GRUB on a BIOS system.
DISK="/dev/nvme0n1"

# A timezone in /usr/share/zoneinfo.
TIME_ZONE="Europe/Stockholm"

# The locale to use.
LOCALE="en_US.UTF-8"

# The keyboard layout to use in /usr/share/kbd/keymaps.
KEYMAP="sv-latin1"

# Hostname for the installation.
_HOSTNAME="Pluto"

# Base packages to be installed.
BASE_PKGS="base base-devel linux linux-firmware"

# Additional packages to be installed.
ADDITIONAL_PKGS="networkmanager"

# Services to enable with systemctl.
SERVICES="NetworkManager"
