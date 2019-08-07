#!/usr/bin/env bash

drive=nvme0n1
lvm=${drive}p3
vol_name=vol0
root_drive=vol0-root
home_drive=vol0-home
boot_drive=${drive}p1
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
my_user=nima

function install_os()
{
    echo "installing OS"

    # Formatting boot partition
    mkfs.fat -F32 /dev/${boot_drive}

    # Opening encrypted lvm partition
    cryptsetup open /dev/${lvm} cryptolvm

    # Formatting root partition
    mkfs.ext4 /dev/mapper/${root_drive}

    # Mounting root, home and boot
    mount /dev/mapper/${root_drive} /mnt
    mkdir /mnt/home
    mount /dev/mapper/${home_drive} /mnt/home
    mkdir /mnt/boot
    mount /dev/${boot_drive} /mnt/boot

    # Installing Arch Linux on root
    echo ${pacman_mirror} > /etc/pacman.d/mirrorlist
    pacstrap /mnt base base-devel wpa_supplicant || exit
    genfstab -U /mnt > /mnt/etc/fstab

    # Setting up locale
    sed -e 's/#  en_US.UTF/en_US.UTF/' /etc/locale.gen > /mnt/etc/locale.gen
    arch-chroot /mnt locale-gen

    # Setting up timezone
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/${my_zone} /etc/localtime

    # Setting hostname
    arch-chroot /mnt echo ${my_hostname} > /etc/hostname

    # Setting up hooks and creating image
    sed -e 's/^HOOKS=([a-zA-Z0-9 ]\{1,\})/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)/' /mnt/etc/mkinitcpio.conf > /mnt/tmp/mkinitcpio.conf
    cp /mnt/tmp/mkinitcpio.conf /mnt/etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux

    # Setting up boot using bootctl
    bootctl --path=/mnt/boot install
    echo -en "Default arch\nTimeout 0\nEditor 0\n" > /mnt/boot/loader/loader.conf
    cryptID=$(blkid /dev/${lvm} | awk '{print $2}' | cut -d\" -f 2)
    echo -en "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions cryptdevice=UUID=${cryptID}:${vol_name} root=/dev/mapper/${root_drive} quite rw\n" > /mnt/boot/loader/entries/arch.conf

    # Setting up username and password
    echo "Set root password"
    arch-chroot /mnt passwd
    echo "Creating your username"
    arch-chroot /mnt useradd -G wheel ${my_user}
    echo "Set password for your username"
    arch-chroot /mnt passws ${my_user}
    sed -e 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers > /mnt/tmp/sudoers
    cp /mnt/tmp/sudoers /mnt/etc/sudoers

    # Finishing up
    umount /mnt/home
    umount /mnt/boot
    umount /mnt

    echo
    echo "Done, reboot!"
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
