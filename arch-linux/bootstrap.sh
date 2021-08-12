#!/bin/sh

curl -O -J https://raw.githubusercontent.com/simonwahll/bootstrap/main/arch-linux/install.sh
curl -O -J https://raw.githubusercontent.com/simonwahll/bootstrap/main/arch-linux/chroot.sh

chmod +x install-arch.sh chroot.sh config.sh

printf "\n"
echo "Make any configurations to config.sh and then run install.sh to install."
