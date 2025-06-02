#!/bin/bash
set -euo pipefail

#---------------------------------------------------------------- 
# Конфигурация
#---------------------------------------------------------------- 

WI_FI_SSID=""               # SSID сети для подключения
WI_FI_PASSWORD=""           # Пароль для подключения к сети
WI_FI_INTERFACE=""          # Интерфейс для подключения
DISK=""                     # Укажите ваш диск (например, /dev/sda, /dev/nvme0n1)
HOSTNAME=""                 # Имя хоста
USERNAME=""                 # Имя пользователя
PASSWORD=""                 # Пароль (лучше изменить)
TIMEZONE="Europe/Moscow"    # Часовой пояс
LOCALE="en_US.UTF-8"        # Локализация
KEYMAP="us"                 # Раскладка клавиатуры

[ -z "$WI_FI_SSID" ] || \ 
[ -z "$WI_FI_PASSWORD" ] || \
[ -z "$WI_FI_INTERFACE"] || \
[ -z "$DISK" ] || \
[ -z "$HOSTNAME" ] || \
[ -z "$USERNAME" ] || \
[ -z "$PASSWORD" ] && {
    echo "Необходимо заполнить все значения конфигурации"
    exit 1
}

#---------------------------------------------------------------- 
# Подключение к сети
#---------------------------------------------------------------- 

if ! systemctl is-active --quiet iwd; then
    echo "Запуск iwd..."
    sudo systemctl start iwd
fi

if ! iwctl device list | grep -q "$WI_FI_INTERFACE"; then
    echo "Интерфейс $WI_FI_INTERFACE не найден!"
    echo "Доступные интерфейсы:"
    iwctl device list
    exit 1
fi

echo "Подключение к: $WI_FI_SSID"
sudo iwctl --passphrase "$WI_FI_PASSWORD" station "$WI_FI_INTERFACE" connect "$WI_FI_SSID"

sleep 3
if iwctl station "$WI_FI_INTERFACE" show | grep -q "Connected"; then
    echo "Подключение к $WI_FI_SSID завершено"
else
    echo "Ошибка подключения. Проверьте параметры сети."
    exit 1
fi

#---------------------------------------------------------------- 
# Разметка диска
#---------------------------------------------------------------- 

echo "Разметка диска..."
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary fat32 1MiB 513MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary ext4 513MiB 100%

mkfs.fat -F32 "${DISK}p1"
mkfs.ext4 -F "${DISK}p2"

#---------------------------------------------------------------- 
# Монтирование
#---------------------------------------------------------------- 

mount "${DISK}p2" /mnt
mkdir -p /mnt/boot/efi
mount "${DISK}p1" /mnt/boot/efi

#---------------------------------------------------------------- 
# Установка базовой системы
#---------------------------------------------------------------- 

echo "Установка базовых пакетов..."
pacstrap /mnt base base-devel linux linux-firmware

#---------------------------------------------------------------- 
# Генерация fstab
#---------------------------------------------------------------- 

genfstab -U /mnt >> /mnt/etc/fstab

#---------------------------------------------------------------- 
# Chroot и настройка системы
#---------------------------------------------------------------- 

arch-chroot /mnt /bin/bash <<EOF
set -euo pipefail

#---------------------------------------------------------------- 
# Настройка времени и локали
#---------------------------------------------------------------- 

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

#---------------------------------------------------------------- 
# Настройка сети
#---------------------------------------------------------------- 

echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS

#---------------------------------------------------------------- 
# Установка загрузчика
#---------------------------------------------------------------- 

bootctl --path=/boot/efi install

$PARTUUID = $(blkid -s PARTUUID -o value ${DISK}p2)

cat > /boot/efi/loader/entries/arch.conf <<BOOT
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$PARTUUID rw
BOOT

#---------------------------------------------------------------- 
# Создание пользователя
#---------------------------------------------------------------- 

useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

#---------------------------------------------------------------- 
# Установка пакетов из официального репозитория
#---------------------------------------------------------------- 

grep -v '^#' ./packages/archlinux.org/core | grep -v '^$' | grep -v '^-' | grep -v '^ ' | sed 's/#.*$//' | sed 's/[[:space:]]*$//' | sed 's/^/core\//' | xargs sudo pacman -S --needed --noconfirm
grep -v '^#' ./packages/archlinux.org/extra | grep -v '^$' | grep -v '^-' | grep -v '^ ' | sed 's/#.*$//' | sed 's/[[:space:]]*$//' | sed 's/^/extra\//' | xargs sudo pacman -S --needed --noconfirm

#---------------------------------------------------------------- 
# https://wiki.hyprland.org/Nvidia/#early-kms-modeset-and-fbdev
#---------------------------------------------------------------- 

NVIDIA_MODULES=("nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm")

for module in "${NVIDIA_MODULES[@]}"; do
    if ! grep -q "MODULES=(.*$module" "$CONFIG_FILE"; then
        sed -i "s/MODULES=(\(.*\))/MODULES=(\1 $module)/" "$CONFIG_FILE"
    fi
done

mkinitcpio -P

#---------------------------------------------------------------- 
# Установка yay и пакетов из AUR репозитория
#---------------------------------------------------------------- 

git clone https://aur.archlinux.org/yay-bin.git
(cd yay-bin && makepkg -si)
rm -rf yay-bin

grep -v '^#' ./packages/aur.archlinux.org/packages | grep -v '^$' | grep -v '^-' | grep -v '^ ' | sed 's/#.*$//' | sed 's/[[:space:]]*$//' | xargs yay -S --needed --noconfirm

#---------------------------------------------------------------- 
# Включение сервисов
#---------------------------------------------------------------- 

systemctl enable NetworkManager

# https://wiki.archlinux.org/title/Bluetooth
systemctl enable bluetooth.service

# https://wiki.hyprland.org/Hypr-Ecosystem/hyprpolkitagent/#usage
systemctl --user enable hyprpolkitagent.service

# TODO: udiskie?

#---------------------------------------------------------------- 
# Копирование конфигов
#---------------------------------------------------------------- 

cp -Rf .config/ ~/

#---------------------------------------------------------------- 
# Завершение
#---------------------------------------------------------------- 

EOF

### === После перезагрузки === ###
echo "Установка завершена! Введите:"
echo "umount -R /mnt"
echo "reboot"