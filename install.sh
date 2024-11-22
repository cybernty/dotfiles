# 1. check
ls /sys/firmware/efi/efivars
ping -c3 archlinux.org

timedatectl set-ntp 1
timedatectl status

# 2. partition
sfdisk /dev/sda <sda.sfdisk
fdisk -l

# 3. format
mkfs.fat -F 32 /dev/sda1

mkfs.ext4 -L BOOT /dev/sda2

mkfs.btrfs -L dev-arch-btrfs /dev/sda3
mount -t btrfs -o compress=zstd /dev/sda3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume list -p /mnt
umount /mnt

# 4. mount
mount -t btrfs -o subvol=/@,compress=zstd /dev/sda3 /mnt

mkdir -p /mnt/efi
mount /dev/sda1 /mnt/efi

mkdir -p /mnt/boot
mount /dev/sda2 /mnt/boot

mkdir -p /mnt/home
mount -t btrfs -o subvol=/@home,compress=zstd /dev/sda3 /mnt/home

# 5. installation
vim /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs

# 6. configure
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

# 7. exit
exit
umount -R /mnt
sync
reboot
