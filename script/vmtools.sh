#!/bin/bash -eux

if [ $PACKER_BUILDER_TYPE == 'vmware-iso' ]; then
    echo "Installing VMware Tools"
    apt-get install -y linux-headers-$(uname -r) build-essential perl gcc

    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /root/linux.iso /mnt/cdrom
    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
    /tmp/vmware-tools-distrib/vmware-install.pl -d
    rm /root/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom

    apt-get -y remove linux-headers-$(uname -r) build-essential perl
    apt-get -y autoremove
elif [ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    VBOX_VERSION=$(cat /root/.vbox_version)
    mount -o loop /root/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /root/VBoxGuestAdditions_${VBOX_VERSION}.iso
fi
