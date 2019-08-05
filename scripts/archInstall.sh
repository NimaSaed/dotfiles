#!/usr/bin/env bash

lvm=nvme0n1p3
vol_name=vol0
root_drive=vol0-root
home_drive=vol0-home
boot_drive=nvme0n1p1
pacman_mirror='Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch'

## Japan
#Server = http://mirrors.cat.net/archlinux/$repo/os/$arch
#Server = https://mirrors.cat.net/archlinux/$repo/os/$arch
#Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
#Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
#Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
#Server = https://jpn.mirror.pkgbuild.com/$repo/os/$arch

my_zone=Asia/Kuala_Lumpur
my_hostname=Archer

function install_os()
{
    echo "installing OS"
    mkfs.fat -F32 /dev/${boot_drive}
    cryptsetup open /dev/${lvm} cryptolvm
    mkfs.ext4 /dev/mapper/${root_drive}
    mount /dev/mapper/${root_drive} /mnt
    mkdir /mnt/home
    mount /dev/mapper/${home_drive} /mnt/home
    mkdir /mnt/boot
    mount /dev/${boot_drive} /mnt/boot
    echo ${pacman_mirror} > /etc/pacman.d/mirrorlist
    pacstrap /mnt base base-devel wpa_supplicant
    genfstab -U /mnt > /mnt/etc/fstab
    sed -e 's/#  en_US.UTF/en_US.UTF/' /etc/locale.gen > /mnt/etc/locale.gen
    arch-chroot /mnt locale-gen
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/${my_zone} /etc/localtime
    arch-chroot /mnt echo ${my_hostname} > /etc/hostname
    sed -e 's/^HOOKS=([a-zA-Z0-9 ]\{1,\})/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)/' /mnt/etc/mkinitcpio.conf > /mnt/tmp/mkinitcpio.conf
    cp /mnt/tmp/mkinitcpio.conf /mnt/etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux

    # Boot
    bootctl --path=/mnt/boot install
    echo -en "Default arch\nTimeout 0\nEditor 0\n" > /mnt/boot/loader/loader.conf
    cryptID=$(blkid /dev/nvme0n1p3 | awk '{print $2}' | cut -d\" -f 2)
    echo -en "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions cryptdevice=UUID=${cryptID}:${vol_name} root=/dev/mapper/${root_drive} quite rw\n" > /mnt/boot/loader/entries/arch.conf

    umount /mnt/home
    umount /mnt/boot
    umount /mnt
    #reboot
}

function format()
{
    echo "format"
}

case "$@" in

    install)
        install_os
        ;;
    format)
        format
        ;;
    *)
        echo "Wrong Option"
        ;;
esac
