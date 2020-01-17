#!/usr/bin/env bash

drive=nvme0n1
lvm=${drive}p2
vol_name=vol0
root_drive=vol0-root
home_drive=vol0-home
boot_drive=${drive}p1
pacman_mirror='Server = https://mirrors.xtom.nl/archlinux/$repo/os/$arch'

# Netherlands
# https://mirror.i3d.net/pub/archlinux/$repo/os/$arch ... 0.123025
# https://mirror.koddos.net/archlinux/$repo/os/$arch ... 0.157417
# https://archmirror.lavatech.top/$repo/os/$arch ... 0.203131
# https://mirror.ams1.nl.leaseweb.net/archlinux/$repo/os/$arch ... 0.117575
# https://archlinux.mirror.liteserver.nl/$repo/os/$arch ... 0.244184
# https://mirror.mijn.host/archlinux/$repo/os/$arch ... 0.085943
# https://mirror.neostrada.nl/archlinux/$repo/os/$arch ... 0.160634
# https://archlinux.mirror.pcextreme.nl/$repo/os/$arch ... 0.108563
# https://archlinux.mirror.wearetriple.com/$repo/os/$arch ... 0.098275
# https://mirror-archlinux.webruimtehosting.nl/$repo/os/$arch ... 0.168727
# https://mirrors.xtom.nl/archlinux/$repo/os/$arch ... 0.079797

my_zone=Europe/Amsterdam
my_hostname=Archer
my_user=nima

function install_os()
{
    echo "installing OS"

    echo "Formatting boot partition"
    mkfs.fat -F32 /dev/${boot_drive}
    sleep 1

    echo "Opening encrypted lvm partition"
    cryptsetup open /dev/${lvm} cryptolvm
    sleep 1

    echo "Formatting root partition"
    mkfs.ext4 /dev/mapper/${root_drive}
    sleep 1

    echo "Mounting root, home and boot"
    mount /dev/mapper/${root_drive} /mnt
    sleep 1
    mkdir /mnt/home
    sleep 1
    mount /dev/mapper/${home_drive} /mnt/home
    sleep 1
    mkdir /mnt/boot
    sleep 1
    mount /dev/${boot_drive} /mnt/boot
    sleep 1

    echo "Installing Arch Linux on root"
    echo ${pacman_mirror} > /etc/pacman.d/mirrorlist
    pacstrap /mnt base base-devel linux linux-firmware mkinitcpio dhcpcd wpa_supplicant lvm2 || exit 1
    sleep 1
    genfstab -U /mnt > /mnt/etc/fstab
    sleep 1

    echo "Setting up locale"
    sed -e 's/#  en_US.UTF/en_US.UTF/' /etc/locale.gen > /mnt/etc/locale.gen
    sleep 1
    arch-chroot /mnt locale-gen
    sleep 1

    echo "Setting up timezone"
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/${my_zone} /etc/localtime
    sleep 1

    echo "Setting hostname"
    arch-chroot /mnt echo ${my_hostname} > /etc/hostname
    sleep 1

    echo "Setting up hooks and creating image"
    sed -e 's/^HOOKS=([a-zA-Z0-9 ]\{1,\})/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)/' /mnt/etc/mkinitcpio.conf > /mnt/tmp/mkinitcpio.conf
    sleep 1
    cp /mnt/tmp/mkinitcpio.conf /mnt/etc/mkinitcpio.conf
    sleep 1
    arch-chroot /mnt mkinitcpio -p linux
    sleep 1

    echo "Setting up boot using bootctl"
    bootctl --path=/mnt/boot install
    sleep 1
    echo -en "Default arch\nTimeout 0\nEditor 0\n" > /mnt/boot/loader/loader.conf
    sleep 1
    cryptID=$(blkid /dev/${lvm} | awk '{print $2}' | cut -d\" -f 2)
    sleep 1
    echo -en "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions cryptdevice=UUID=${cryptID}:${vol_name} root=/dev/mapper/${root_drive} quite rw\n" > /mnt/boot/loader/entries/arch.conf
    sleep 1

    echo "Setting up username and password"
    echo "Set root password"
    arch-chroot /mnt passwd
    echo "Creating your username"
    arch-chroot /mnt useradd -G wheel ${my_user}
    sleep 1
    echo "Set password for your username"
    arch-chroot /mnt passwd ${my_user}
    sleep 1
    sed -e 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers > /mnt/tmp/sudoers
    sleep 1
    cp /mnt/tmp/sudoers /mnt/etc/sudoers
    sleep 1

    echo "Finishing up"
    umount /mnt/home
    umount /mnt/boot
    umount /mnt

    echo
    echo "Done, reboot!"
    #reboot
}

function format()
{
    echo "Format the drive"
    wipefs -a /dev/${drive}
    parted -s /dev/${drive} mklabel gpt \
        mkpart primary fat32 1MiB 261MiB \
        set 1 esp on \
        mkpart primary 261MiB 100% \
        set 2 lvm on

    cryptsetup luksFormat --type luks2 /dev/${lvm}
    cryptsetup open /dev/${lvm} cryptlvm
    pvcreate /dev/mapper/cryptlvm
    gvcreate vol0 /dev/mapper/cryptlvm
    lvcreate -L sizeG vol0 -n root
    cryptsetup close cryptlvm
    echo "Done"
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
