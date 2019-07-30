#!/usr/bin/env bash

lvm=nvme0n1p3
root_drive=vol0-root
home_drive=vol0-home
boot_drive=nvme0n1p1
pacman_mirror=path
my_zone=Asia/Kuala_Lumpur
my_hostname=Archer

function install_os()
{
    echo "installing OS"

    cryptosetup open /dev/${lvm} cryptolvm
    mkfs.ext4 /dev/mapper/${root_drive}
    mount /dev/mapper/${root_drive} /mnt
    mkdir /mnt/home
    mount /dev/mapper/${home_drive} /mnt/home
    mkdir /mnt/boot
    mount /dev/${boot_drive} /mnt/boot
    echo ${pacman_mirror} > /etc/pacman.d/mirrorlist
    pacstrap /mnt base
    genfstab -U /mnt > /mnt/etc/fstab

    ## need to fix
    #arch-chroot /mnt
    #vi /etc/locale.gen
    #locale-gen
    #ln -sf /usr/share/zoneinfo/${my_zone} /etc/localtime
    #echo ${my_hostname} > /etc/hostname
    #HOOKS=(base udev autodetect **keyboard** **keymap** consolefont modconf block **encrypt** **lvm2** filesystems fsck)
    #mkinitcpio -p linux
    ## exit arch-chroot
    #umount /mnt/home
    #umount /mnt/boot
    #umount /mnt
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
