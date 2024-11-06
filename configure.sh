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
        -h | --help)
            help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            help
            exit 1
            ;;
        esac
        shift
    done
}

base() {
    systemctl enable --now dhcpcd.service
    systemctl status dhcpcd.service
    ping -c3 www.google.com || {
        echo "Network not reachable."
        exit 1
    }

    sed -i 's/#Color/Color/' /etc/pacman.conf
    pacman -Syu
    pacman -S \
        base-devel \
        fastfetch \
        git \
        man \
        neovim \
        openssh \
        zsh
    ln -sf /usr/bin/nvim /usr/bin/vi

    useradd -mG wheel -s /bin/zsh dev
    passwd dev
    # visudo
    echo "dev ALL=(ALL) ALL" | EDITOR="tee -a" visudo
    reboot
}

fonts() {
    sudo pacman -S noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        noto-fonts-extra
}

shell() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc
    sed -i '/^ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc
}

window_manager() {
    sudo pacman -S xorg xorg-xinit

    make
    cp .xinitrc ~/.xinitrc
    # startx
}

display_manager() {
    sudo pacman -S lightdm lightdm-gtk-greeter

    sudo mkdir -p /usr/share/xsessions
    cat <<EOF | sudo tee /usr/share/xsessions/dwm.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=The dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF

    # lightdm --test-mode --debug
    sudo systemctl enable lightdm.service
}

_git() {
    git config --global user.name local
    git config --global user.email local
    git config --global init.defaultBranch main

    ssh-keygen -f ~/.ssh/github
    cat <<EOF >~/.ssh/config
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/github
EOF

    sudo pacman -S lazygit
    echo "alias lg='lazygit'" >>~/.zshrc
}

aur() {
    git clone --depth 1 https://aur.archlinux.org/yay.git && cd yay
    makepkg -si
    yay --version
    pacman -Qs yay
}

editor() {
    yay -S visual-studio-code-bin

    [ -d ~/.config/nvim ] && mv ~/.config/nvim{,.bak}
    git clone --depth 1 https://github.com/NvChad/starter ~/.config/nvim
}

browser() {
    sudo pacman -S chromium
}

input_method() {
    sudo pacman -S fcitx5-im
    sudo pacman -S fcitx5-chinese-addons
    mkdir -p ~/.config/environment.d
    cat <<EOF | sudo tee ~/.config/environment.d/im.conf
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
EOF
    echo 'fcitx5 -d &>/dev/null' >>~/.zshrc
    # fcitx5-configtool
}

dev_env() {
    sudo pacman -S jdk21-openjdk maven

    # - [Java - ArchWiki](https://wiki.archlinux.org/title/Java#Impersonate_another_window_manager)
    #     - [Java - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/Java)
    # - [Arch Linux - Package Search](https://archlinux.org/packages/?name=wmname)
    # - [tools | suckless.org software that sucks less](https://tools.suckless.org/x/wmname/)
    sudo pacman -S wmname
    # wmname LG3D
    # idea &
}

_docker() {
    sudo pacman -S docker
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker "$USER"
    newgrp docker
    # docker images -a; echo; docker ps -a

    sudo pacman -S docker-compose
    docker compose version
}

terminal() {
    yay -S alacritty
}

terminal_multiplexer() {
    yay -S tmux
    yay -S zellij
    echo "alias tmux='zellij'" >>~/.zshrc
}

file_manager() {
    yay -S yazi
    echo "alias fm='yazi'" >>~/.zshrc
}

monitor() {
    sudo pacman -S htop
    sudo pacman -S btop
    sudo pacman -S conky
}

_wireshark() {
    sudo pacman -S wireshark-qt
    sudo usermod -aG wireshark "$USER"
    newgrp wireshark
}

misc() {
    sudo pacman -S dua-cli \
        tree \
        unzip
    yay -S fd
    yay -S fzf
    yay -S polybar
    yay -S nmap

    yay -S bat
    echo "alias cat='bat'" >>~/.zshrc
}

main() {
    parse_args "$@"

    if (("$(id -u)" == 0)); then
        base
    else
        fonts
        shell
        window_manager
        display_manager
        _git
        aur
        editor
        browser
        input_method
        dev_env
        _docker
        terminal
        terminal_multiplexer
        file_manager
        monitor
        _wireshark
        misc
    fi
    reboot
}

main "$@"
