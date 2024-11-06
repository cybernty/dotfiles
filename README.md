# dotfiles

## Usage

1. install arch linux: [guide](./install.sh)
2. network: `systemctl start dhcpcd.service`
3. dotfiles: `pacman -S git && cd /tmp && git clone --depth 1 https://github.com/cybernty/dotfiles.git && cd dotfiles`
4. basic config: `./configure.sh`
5. advance: `cd /tmp && git clone --depth 1 https://github.com/cybernty/dotfiles.git && ./dotfiles/configure.sh`

## List

| type                 | use                                                      |
| -------------------- | -------------------------------------------------------- |
| window manager       | dwm                                                      |
| display manager      | lightdm                                                  |
| shell                | zsh(ohmyzsh)                                             |
| terminal             | alacritty                                                |
| terminal multiplexer | tmux, zellij                                             |
| editor               | neovim + vscode                                          |
| git                  | lazygit                                                  |
| file manager         | yazi                                                     |
| browser              | chromium                                                 |
| package manager      | pacman + yay                                             |
| font                 | noto                                                     |
| input method         | fcitx5                                                   |
| monitor              | ~~htop~~ btop, conky                                     |
| misc                 | fastfetch, docker, wireshark, dua, fd, fzf, polybar, bat |
