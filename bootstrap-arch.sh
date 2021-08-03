#!/bin/sh

curl -O -J https://raw.githubusercontent.com/simonwahll/bootstrap/main/install-arch.sh
curl -O -J https://raw.githubusercontent.com/simonwahll/bootstrap/main/chroot.sh

chmod +x install-arch.sh chroot.sh

./install-arch.sh
