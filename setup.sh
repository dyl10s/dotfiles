#!/bin/bash

cd ~

# Install Tools
sudo apt install gh tmux zsh stow ninja-build gettext cmake unzip curl build-essential

# Default zsh sell
chsh -s $(which zsh)

# Configure Github
gh auth login

# Node Version
curl -fsSL https://fnm.vercel.app/install | bash
fnm install 18
fnm use 18

# Dotfiles
git clone https://github.com/dyl10s/dotfiles
cd dotfiles

stow custom-scripts
stow nvim
stow tmux
stow zsh

# Neovim
mkdir ~/repos
cd ~/repos
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ~


