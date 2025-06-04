#!/bin/bash
set -euo pipefail
cat <<"EOF"

-------------------------------------------------    

88888888ba,                            ad88  88  88                         
88      `"8b                 ,d       d8"    ""  88                         
88        `8b                88       88         88                         
88         88   ,adPPYba,  MM88MMM  MM88MMM  88  88   ,adPPYba,  ,adPPYba,  
88         88  a8"     "8a   88       88     88  88  a8P_____88  I8[    ""  
88         8P  8b       d8   88       88     88  88  8PP"""""""   `"Y8ba,   
88      .a8P   "8a,   ,a8"   88,      88     88  88  "8b,   ,aa  aa    ]8I  
88888888Y"'     `"YbbdP"'    "Y888    88     88  88   `"Ybbd8"'  `"YbbdP"'  

-------------------------------------------------

EOF

DISKS=$(lsblk -d -n -o NAME,SIZE,MODEL | awk '{print "/dev/"$1, $2, $3}' | grep -v "loop")
echo "💿 Select a disk on which the OS will be installed:" # (e.g. /dev/sda, /dev/nvme0n1)
DISK=$(echo "$DISKS" | fzf --height=40% --reverse --prompt="Select disk > " | awk '{print $1}')
[[ -z "$DISK" ]] && { echo "❌ No disk selected. Aborting."; exit 1; }
echo "✅ Selected disk: $DISK"

read -rp "🌐 Enter hostname: " HOSTNAME
[[ -z "$HOSTNAME" ]] && { echo "❌ Hostname cannot be empty."; exit 1; }

read -rp "🥷 Enter username: " USERNAME
[[ -z "$USERNAME" ]] && { echo "❌ Username cannot be empty."; exit 1; }

while true; do
    read -rsp "🔑 Enter password for $USERNAME: " PASSWORD
    echo
    read -rsp "🔑 Confirm password: " PASSWORD_CONFIRM
    echo
    if [[ "$PASSWORD" == "$PASSWORD_CONFIRM" ]]; then
        break
    else
        echo "❌ Passwords do not match. Try again."
    fi
done

TIMEZONE="Europe/Moscow"    # Time zone identifier using IANA database format (Region/City)
LOCALE="en_US.UTF-8"        # System localization settings (language_COUNTRY.character-encoding)
KEYMAP="us"                 # Keyboard layout identifier for virtual console

echo -e "\n📝 Installation settings:"
echo "Disk:      $DISK"
echo "Hostname:  $HOSTNAME"
echo "Username:  $USERNAME"
echo "Timezone:  $TIMEZONE"
echo "Locale:    $LOCALE"
echo "Keymap:    $KEYMAP"

read -rp "❓ Proceed with installation? (y/N): " CONFIRM
[[ "$CONFIRM" != [yY] ]] && { echo "❌ Installation aborted."; exit 1; }

echo "🔪 Partitioning a disk"
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary fat32 1MiB 513MiB
parted -s "$DISK" set 1 esp on
parted -s "$DISK" mkpart primary ext4 513MiB 100%

mkfs.fat -F32 "${DISK}p1"
mkfs.ext4 -F "${DISK}p2"

echo "🔌 Mounting"
mount "${DISK}p2" /mnt
mkdir -p /mnt/boot
mount "${DISK}p1" /mnt/boot

echo "📦 Installing the kernel and base packages"
pacstrap -K /mnt base base-devel linux linux-firmware

echo "👉 generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "🌀 Copying dotfiles for use in crhoot"
mkdir /mnt/opt/dotfiles
cp -r . /mnt/opt/dotfiles

arch-chroot /mnt /bin/bash <<EOF
set -euo pipefail

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS

bootctl install
cat > /boot/loader/entries/arch.conf <<BOOT
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value "${DISK}p2") rw
BOOT

useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
echo "%wheel ALL=(ALL) ALL
$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

su - "$USERNAME" <<'EOF_USER'
    awk '{print \$1}' /opt/dotfiles/packages/archlinux.org | xargs sudo pacman -Syu --needed --noconfirm

    git clone https://aur.archlinux.org/paru.git
    cd ./paru
    makepkg -si --noconfirm
    cd ../
    rm -rf ./paru

    awk '{print \$1}' /opt/dotfiles/packages/aur.archlinux.org | xargs paru -Syu --needed --noconfirm --skipreview

    sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
    sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
    echo "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
    echo "[General]\nInputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
    sudo sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/pixel_sakura.conf|g' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
EOF_USER

sed -i '$ d' /etc/sudoers

cp -Rf /opt/dotfiles/.config /home/$USHERNAME/
chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

# https://wiki.hyprland.org/Nvidia/#early-kms-modeset-and-fbdev

CONFIG_FILE="/etc/mkinitcpio.conf"
NVIDIA_MODULES=("nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm")

for module in "\${NVIDIA_MODULES[@]}"; do
    if ! grep -q "MODULES=(.*\$module" "\$CONFIG_FILE"; then
        sed -i "s/MODULES=(\(.*\))/MODULES=(\1 \$module)/" "\$CONFIG_FILE"
    fi
done

mkinitcpio -P

systemctl enable NetworkManager
# https://wiki.archlinux.org/title/Bluetooth
systemctl enable bluetooth.service
# https://wiki.hyprland.org/Hypr-Ecosystem/hyprpolkitagent/#usage
systemctl --user enable hyprpolkitagent.service

EOF

echo "🎉 Installation completed"
read -r -n 1 -p "Reboot now ? (y/n): " answer
echo

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    umount -R /mnt
    reboot
else
    exit 0
fi
