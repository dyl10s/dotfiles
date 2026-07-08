#!/usr/bin/env bash
cd ~

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

# Install CLI tools & apps
brew install gh tmux zsh stow cmake unzip curl ninja gettext luarocks ripgrep fzf lazygit node wget fnm htop imagemagick
brew install --cask wezterm     # confirmed available :contentReference[oaicite:1]{index=1}
brew install --cask obsidian
brew install --cask slack
brew install --cask studio-3t   # confirmed available :contentReference[oaicite:2]{index=2}
brew install --cask google-chrome
brew install --cask pgadmin4
brew install postgresql@17
brew install podman
brew install withgraphite/tap/graphite
brew install --cask zoom
brew install --cask linear

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
git config --global user.email "dylan.strohschein@dynatrace.com"
git config --global user.name "Dylan Strohschein"

# Desktop wallpaper
WALLPAPER="$HOME/dotfiles/wallpapers/work.png"
if [ -f "$WALLPAPER" ]; then
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
fi

# Remap Caps Lock to Escape (persists across reboots via LaunchAgent)
KEYMAP_PLIST="$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$KEYMAP_PLIST" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.local.KeyRemapping</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/hidutil</string>
    <string>property</string>
    <string>--set</string>
    <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
launchctl unload "$KEYMAP_PLIST" 2>/dev/null || true
launchctl load "$KEYMAP_PLIST"

# Style new screenshots and copy them to the clipboard (watches the
# screenshot save location and runs ~/custom-scripts/screenshot-style).
# Screenshots save to ~/Screenshots instead of a TCC-protected folder
# (Documents/Desktop/Downloads) so the background agent can read them.
SCREENSHOT_DIR="$HOME/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
defaults write com.apple.screencapture location "$SCREENSHOT_DIR"
SCREENSHOT_PLIST="$HOME/Library/LaunchAgents/com.local.ScreenshotStyle.plist"
cat > "$SCREENSHOT_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.local.ScreenshotStyle</string>
  <key>ProgramArguments</key>
  <array>
    <string>$HOME/custom-scripts/screenshot-style</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>$SCREENSHOT_DIR</string>
  </array>
  <key>StandardOutPath</key>
  <string>/tmp/screenshot-style.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/screenshot-style.log</string>
</dict>
</plist>
EOF
launchctl unload "$SCREENSHOT_PLIST" 2>/dev/null || true
launchctl load "$SCREENSHOT_PLIST"

# Apply changes
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

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

# Install Nerd Font (Agave)
FONT_DIR="$HOME/Library/Fonts"
if [ ! -f "$FONT_DIR/AgaveNerFont-Regular.ttf" ]; then
  echo "Installing Agave Nerd Font..."
  wget -P /tmp https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Agave.zip
  unzip -o /tmp/Agave.zip -d "$FONT_DIR"
  rm /tmp/Agave.zip
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

# Podman helper
sudo /opt/homebrew/bin/podman-mac-helper install

# Initialize the podman machine (zshrc handles starting it)
podman machine init

# Graphite auth
echo "Visit https://app.graphite.com/activate"
read -s -p "Enter your Graphite CLI Token: " GRAPHITE_CLI_TOKEN
gt auth --token $GRAPHITE_CLI_TOKEN
