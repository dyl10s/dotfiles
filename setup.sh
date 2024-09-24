#!/bin/bash

cd ~

# Install Tools
sudo apt install gh tmux zsh stow ninja-build gettext cmake unzip curl build-essential luarocks

# Default zsh sell
chsh -s $(which zsh)

# Configure Github
if ! gh auth status &>/dev/null; then
    echo "You are not logged in. Please log in."
    gh auth login
else
    echo "Skipping GitHub Login"
fi

# Node Version
if ! fnm --version &>/dev/null; then
	curl -fsSL https://fnm.vercel.app/install | bash
	fnm install 18
	fnm use 18
else
    echo "Skipping fnm download"
fi

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Dotfiles
if [ -d "$HOME/dotfiles" ]; then
    echo "Skipping dotfile clone"
	cd ~/dotfiles
	git pull
else
	git clone https://github.com/dyl10s/dotfiles
	cd dotfiles
	git submodule update --init --recursive 
fi

# Git setup
git config --global user.email "dylanstrohschein@gmail.com"
git config --global user.name "Dylan Strohschein"

stow custom-scripts
stow nvim
stow tmux
stow zsh

# Neovim
echo "Installing Neovim"
if [ -d "$HOME/repos/neovim" ]; then
    echo "Neovim already detected, updating..."
	cd ~/repos/neovim
	git checkout stable
	make CMAKE_BUILD_TYPE=RelWithDebInfo &>/dev/null
	sudo make install &>/dev/null
else
	mkdir ~/repos
	cd ~/repos
	git clone https://github.com/neovim/neovim
	cd neovim
	git checkout stable
	make CMAKE_BUILD_TYPE=RelWithDebInfo &>/dev/null
	sudo make install &>/dev/null
fi
echo "Neovim install complete"

# Obsidian
echo "Installing Obsidian"
snap install obsidian --classic
if [ ! -d "$HOME/Documents/Merch" ]; then
	mkdir "$HOME/Documents/Merch"
fi

cd ~



