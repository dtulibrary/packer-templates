#!/bin/bash -eux

if [ $PACKER_BUILDER_TYPE == 'vmware-iso' ]; then
    echo "Installing VMware Tools"

    mkdir -p /mnt/hgfs
    apt-get update
    apt-get install -y open-vm-tools module-assistant linux-headers-amd64 linux-image-amd64 open-vm-tools-dkms
    module-assistant prepare
    module-assistant --text-mode -f get open-vm-tools-dkms

    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove
elif [ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    VBOX_VERSION=$(cat /var/tmp/.vbox_version)
    modprobe loop
    mount -o loop /var/tmp/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /var/tmp/VBoxGuestAdditions_${VBOX_VERSION}.iso
fi
