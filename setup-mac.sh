#!/usr/bin/env bash
cd ~

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

# Install CLI tools & apps
brew install gh tmux zsh stow cmake unzip curl ninja gettext luarocks ripgrep fzf lazygit node wget fnm
brew install --cask wezterm     # confirmed available :contentReference[oaicite:1]{index=1}
brew install --cask obsidian
brew install --cask slack
brew install --cask studio-3t   # confirmed available :contentReference[oaicite:2]{index=2}
brew install --cask google-chrome

# Set default shell
chsh -s "$(which zsh)"

# Stow configurations
cd ~/dotfiles
stow custom-scripts
stow nvim
stow git-hooks
stow tmux
stow zsh
stow wezterm
stow ghostty
stow gh-dash

# GH CLI login
if ! gh auth status &>/dev/null; then
  echo "Please log in to GitHub..."
  gh auth login
else
  echo "Skipping GitHub login"
fi

# fnm (Node version manager)
if ! command -v fnm &>/dev/null; then
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.fnm:$PATH"
  eval "$(fnm env)"
  fnm install 18
  fnm use 18
else
  echo "fnm already installed"
  eval "$(fnm env)"
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Dotfiles
if [ -d "$HOME/dotfiles" ]; then
  echo "Updating dotfiles..."
  cd ~/dotfiles && git pull && git submodule update --init --recursive
else
  echo "Cloning dotfiles..."
  git clone https://github.com/dyl10s/dotfiles ~/dotfiles
  cd ~/dotfiles && git submodule update --init --recursive
fi

# Git global config
git config --global user.email "dylanstrohschein@gmail.com"
git config --global user.name "Dylan Strohschein"

# Neovim fetch (if defined)
sudo neovim-fetch

# Install Nerd Font (CascadiaCode)
FONT_DIR="$HOME/Library/Fonts"
if [ ! -f "$FONT_DIR/CaskaydiaCoveNerdFont-Bold.ttf" ]; then
  echo "Installing CascadiaCode Nerd Font..."
  wget -P /tmp https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip
  unzip -o /tmp/CascadiaCode.zip -d "$FONT_DIR"
  rm /tmp/CascadiaCode.zip
  echo "Font installed"
fi

# Lua Mongo driver (may require Xcode + Mongo C driver)
luarocks install lua-mongo || echo "lua-mongo install needs Xcode or mongo-c-driver"

# Global npm tools
npm install -g cspell
npm install -g eslint_d

# GitHub CLI extension
gh extension install dlvhdr/gh-dash

# Git hooks path
git config --global core.hooksPath ~/.config/git-hooks
