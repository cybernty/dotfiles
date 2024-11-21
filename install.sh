ls /sys/firmware/efi/efivars
ping -c3 archlinux.org

timedatectl set-ntp 1
timedatectl status

fdisk -l
sfdisk /dev/sda < sda.sfdisk

mkfs.vfat -n EFI /dev/sda1
mkfs.ext4 -L ROOT /dev/sda2
mkfs.ext4 -L HOME /dev/sda3

mount /dev/sda2 /mnt
mkdir -p /mnt/efi
mount /dev/sda1 /mnt/efi
mkdir -p /mnt/home
mount /dev/sda3 /mnt/home

# vim /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs
genfstab -U /mnt >>/mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf
echo "arch" >>/etc/hostname
passwd

pacman -S amd-ucode grub efibootmgr os-prober networkmanager

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=ARCH
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5"' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt
sync
reboot
