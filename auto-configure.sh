#!/usr/bin/env bash
set -Eeuo pipefail


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


base() {
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


fonts() {
    sudo pacman -S noto-fonts \
                    noto-fonts-cjk \
                    noto-fonts-emoji \
                    noto-fonts-extra
}


main() {
    parse_args "$@"

    if (( "$(id -u)" == 0 )); then
        base
    else
        fonts
    fi

}


main "$@"
