#!/usr/bin/env bash


dir=$(dirname $(dirname $(readlink -f "$0")))

drive=nvme0n1
lvm=${drive}p2
vol_name=vol0
root_drive=vol0-root
root_drive_size=120 # Gigabyte
home_drive=vol0-home
boot_drive=${drive}p1
pacman_country="DE" # Germany


my_zone=Europe/Amsterdam
my_hostname=Archer
my_user=nima

function install_os()
{
    if [ -e ${dir}/scripts/archPackages ];
    then
        package_list=$(cat ${dir}/scripts/archPackages | grep ^[^#]);
    else echo "cannot find packages file"; exit 1;
    fi

    rankmirrors &> /dev/null
    if [ "$?" == "127" ];
    then
        echo "installing rankmirrors"
	    pacman -Sy
	    pacman -S pacman-contrib --noconfirm
    fi

    echo "running rankmirrors"
    curl -s "https://archlinux.org/mirrorlist/?country=${pacman_country}&protocol=https&ip_version=4" | cut -c2- > mirrors
    rankmirrors -n ${4:-1} -v mirrors | tee > /etc/pacman.d/mirrorlist

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

    pacstrap /mnt base base-devel linux linux-firmware mkinitcpio dhcpcd iwd lvm2 $package_list || exit 1
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
    arch-chroot /mnt useradd -G wheel -m ${my_user}
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
    pvcreate -ff /dev/mapper/cryptlvm
    vgcreate ${vol_name} /dev/mapper/cryptlvm
    lvcreate -L ${root_drive_size}G ${vol_name} -n root
    lvcreate -l 100%FREE ${vol_name} -n home
    mkfs.ext4 /dev/mapper/${home_drive}
    cryptsetup close ${home_drive}
    cryptsetup close ${root_drive}
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
