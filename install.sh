# ---------- less (bios)----------
ping -c3 archlinux.org

timedatectl

fdisk -l
cfdisk
# dos: sda1

mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

# vim /etc/pacman.d/mirrorlist
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

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt
reboot
# ---------- end ----------


# ---------- more (uefi)----------
ls /sys/firmware/efi/efivars
ping -c3 archlinux.org

timedatectl set-ntp 1
timedatectl status

fdisk -l
cfdisk
# gpt: sda1 + sda2

mkfs.vfat /dev/sda1
mkfs.btrfs -L dev-arch-btrfs /dev/sda2
mount -t btrfs -o compress=zstd /dev/sda2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
# btrfs subvolume list -p /mnt
umount /mnt
mount -t btrfs -o subvol=/@,compress=zstd /dev/sda2 /mnt
mkdir /mnt/home
mount -t btrfs -o subvol=/@home,compress=zstd /dev/sda2 /mnt/home
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# vim /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs
genfstab -U /mnt >>/mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf
echo "arch" >>/etc/hostname
passwd

pacman -S amd-ucode grub efibootmgr os-prober dhcpcd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5"/' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt
reboot
# ---------- end ----------
