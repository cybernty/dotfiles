ping -c3 archlinux.org

timedatectl

fdisk -l
cfdisk

mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >>/mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf
echo "arch" >>/etc/hostname
passwd

pacman -S grub amd-ucode os-prober dhcpcd
echo $?

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt
reboot
