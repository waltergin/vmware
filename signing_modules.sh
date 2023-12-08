#!/bin/bash

# https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/how-to-install-vmware-workstation-16-pro-on-ubuntu-22-04-ubuntu-20-04.html

VMWARE_VERSION=workstation-16.2.3
TMP_FOLDER=/tmp/patch-vmware
rm -fdr $TMP_FOLDER
mkdir -p $TMP_FOLDER
cd $TMP_FOLDER
sudo apt install git -y
git clone https://github.com/mkubecek/vmware-host-modules.git
cd $TMP_FOLDER/vmware-host-modules
git checkout $VMWARE_VERSION
git fetch
make
sudo make install
sudo rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
sudo ln -s /lib/x86_64-linux-gnu/libz.so.1 /usr/lib/vmware/lib/libz.so.1/libz.so.1
sudo apt install -y openssl

sudo mkdir -p /misc/sign-vmware-modules

sudo chmod 777 /misc/sign-vmware-modules

cd /misc/sign-vmware-modules

openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=MSI/"

chmod 600 MOK.priv

# uefimokkey

sudo mokutil --import MOK.der

cp signingscript /misc/sign-vmware-modules/signingscript

sudo chmod 700 /misc/sign-vmware-modules/signingscript

sudo /misc/sign-vmware-modules/signingscript 



