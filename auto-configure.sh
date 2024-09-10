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


shell() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
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
Comment=the dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF

    # lightdm --test-mode --debug
    sudo systemctl enable lightdm.service
}


aur() {
    git clone https://aur.archlinux.org/yay.git --depth 1 && cd yay
    makepkg -si
    yay --version
    pacman -Qs yay
}


vscode() {
    yay -S visual-studio-code-bin

    code --install-extension ms-azuretools.vscode-docker
}


_git() {
    git config --global user.name local
    git config --global user.email local
    git config --global init.defaultBranch main

    ssh-keygen -f ~/.ssh/github
cat <<EOF > ~/.ssh/config
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/github
EOF

    yay lazygit
}


browser() {
    sudo pacman -S chromium
}


input_method() {
    sudo pacman -S fcitx5-im
    sudo pacman -S fcitx5-chinese-addons
    sudo nvim /etc/environment
    # GTK_IM_MODULE=fcitx
    # QT_IM_MODULE=fcitx
    # XMODIFIERS=@im=fcitx
    reboot
    fcitx5-configtool
    echo 'fcitx5 -d' >> ~/.zshrc
}


dev_env() {
    sudo pacman -S jdk21-openjdk maven intellij-idea-community-edition

    # - [Java - ArchWiki](https://wiki.archlinux.org/title/Java#Impersonate_another_window_manager)
    #     - [Java - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/Java)
    # - [Arch Linux - Package Search](https://archlinux.org/packages/?name=wmname)
    # - [tools | suckless.org software that sucks less](https://tools.suckless.org/x/wmname/)
    sudo pacman -S wmname
    wmname LG3D
    idea
}


clis() {
    sudo pacman -S tree netcat dua-cli
    yay unzip
    yay zellij
    yay fd

    yay yazi
    yay fzf
    yay alacritty
    yay tmux

    mv ~/.config/nvim{,.bak}
    git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

    yay bat
    yay conky
    yay polybar
    yay pandoc
}


main() {
    parse_args "$@"

    if (( "$(id -u)" == 0 )); then
        base
    else
        fonts
        shell
        window_manager
        display_manager
        aur
        vscode
        _git
        browser
        input_method
        dev_env
        clis
    fi
}


main "$@"
