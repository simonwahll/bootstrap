#!/bin/sh

wget https://github.com/simonwahll/bootstrap/blob/main/install-arch.sh
wget https://github.com/simonwahll/bootstrap/blob/main/chroot.sh

chmod +x install-arch.sh chroot.sh

./install-arch.sh
