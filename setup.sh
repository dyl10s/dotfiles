#!/bin/bash

cd ~

# Add repos
# Wezterm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

# Update repos
sudo apt update

# Install apt packages
sudo apt install gh tmux zsh stow ninja-build gettext cmake unzip curl build-essential luarocks wezterm libmongoc-dev fzf

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
stow wezterm

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
cd ~

# Obsidian
echo "Installing Obsidian"
snap install obsidian --classic
if [ ! -d "$HOME/Documents/Merch" ]; then
	mkdir "$HOME/Documents/Merch"
fi
cd ~

# Font
if [ ! -d "~/.local/share/fonts/CascadiaCode" ]; then
	echo "Installing CascadiaCode Font"
	wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip
	cd ~/.local/share/fonts
	unzip CascadiaCode.zip
	rm CascadiaCode.zip
	fc-cache -fv
	echo "Font install complete"
fi
cd ~

# Mongo NVIM Plugin
sudo luarocks install lua-mongo

# NPM Global Tools
npm install -g cspell

# Wezterm as default
sudo update-alternatives --set x-terminal-emulator /usr/bin/open-wezterm-here
