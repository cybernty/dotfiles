#!/usr/bin/env bash
set -Eeuxo pipefail


help() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [options]

Auto configure Arch Linux

Available options:
  -h, --help      Print this help and exit
EOF
}


parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                help
                exit 1
                ;;
        esac
    done
}


_base() {
    systemctl enable dhcpcd.service
    systemctl start dhcpcd.service
    systemctl status dhcpcd.service
    ping -c3 www.google.com

    sed -i 's/#Color/Color/' /etc/pacman.conf
    pacman -Syu
    pacman -S base-devel \
                fastfetch \
                git \
                htop \
                man \
                neovim \
                openssh \
                zsh
    ln -s /usr/bin/nvim /usr/bin/vi

    useradd -m -G wheel -s /bin/zsh develop
    passwd develop
    visudo
    reboot
}


_fonts() {
    sudo pacman -S noto-fonts \
                    noto-fonts-cjk \
                    noto-fonts-emoji \
                    noto-fonts-extra
}


_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
    sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc
    sed -i '/^ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

    exec zsh
}


_dwm() {
    sudo pacman -S xorg xorg-xinit

    make
    cp /etc/X11/xinit/xinitrc ~/.xinitrc
    nvim ~/.xinitrc
    startx
}


main() {
    parse_args "$@"

    if (( "$(id -u)" == 0 )); then
        _base
    else
        _fonts
        _zsh
        _dwm
    fi

}


main "$@"
