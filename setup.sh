#!/bin/bash

# Install Tools
sudo apt install gh tmux zsh stow ninja-build gettext cmake unzip curl build-essential

stow custom-scripts
stow nvim
stow tmux
stow zsh

# Default zsh sell
chsh -s $(which zsh)

gh auth login

# Dotfiles
git clone https://github.com/dyl10s/dotfiles

# Neovim
mkdir ~/repos
cd ~/repos
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ~


