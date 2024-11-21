# dotfiles

## Configurations

| Type                     | Tool/Use                                                                                                                                                       |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Window Manager**       | dwm                                                                                                                                                            |
| **Display Manager**      | lightdm                                                                                                                                                        |
| **Shell**                | zsh + [atuin](https://github.com/atuinsh/atuin) + [zoxide](https://github.com/ajeetdsouza/zoxide)                                                              |
| **Terminal**             | ~~st~~, alacritty                                                                                                                                                      |
| **Terminal Multiplexer** | ~~tmux~~, zellij                                                                                                                                               |
| **Editor**               | neovim  + vscode                                                                                                                                               |
| **File Manager**         | yazi                                                                                                                                                           |
| **Browser**              | ~~chromium~~, chrome                                                                                                                                                       |
| **Package Managers**     | pacman + yay (AUR helper)                                                                                                                                      |
| **Fonts**                | Noto                                                                                                                                                           |
| **Input Method**         | fcitx5 + [fcitx5-nord](https://github.com/tonyfettes/fcitx5-nord)                                                                                              |
| **System Monitor**       | ~~htop~~, btop, conky                                                                                                                                          |
| **Git**                  | lazygit, git-delta                                                                                                                                             |
| **Screenshot**           | flameshot                                                                                                                                                      |
| **Miscellaneous**        | fastfetch, lazydocker, wireshark, dua-cli, fd, fzf, bat, [ripgrep](https://github.com/BurntSushi/ripgrep), [thefuck](https://github.com/nvbn/thefuck) |

<!--
## Usage

1. install arch linux: [guide](./install.sh)
2. network: `systemctl start NetworkManager.service`
3. dotfiles: `pacman -S git && git clone --depth 1 https://github.com/cybernty/dotfiles.git && cd dotfiles`
4. basic config: `./configure.sh`
5. advanced config: `sudo mv /root/dotfiles . && sudo chown -R dev:dev dotfiles && cd dotfiles && ./configure.sh`
-->
