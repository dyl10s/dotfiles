# Enable startup debug time
# zmodload zsh/zprof
source ~/secrets.sh

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/custom-scripts:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Speed up nvm plugin with lazy loading
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -z "$TMUX" ]
then
	tmux attach || tmux
fi

# bun completions
[ -s "/home/dylan/.bun/_bun" ] && source "/home/dylan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# go
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
# sets the tempdir for go because of kandji being mean
# export TMPDIR=$HOME/tmp && mkdir -p $TMPDIR


# fnm aliased as nvm
FNM_PATH="/home/dylan/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/dylan/.local/share/fnm:$PATH"
fi

# fnm for mac
FNM_PATH="/opt/homebrew/bin"
if [ -d "$FNM_PATH" ]; then
  export PATH="/opt/homebrew/bin/fnm:$PATH"
fi

eval "$(fnm env --use-on-cd --shell zsh)"

alias nvm="fnm"

# Enable startup debug time
# zprof

# Turso
export PATH="/home/dylan/.turso:$PATH"

# Python install dir
export PATH="/home/dylan/.local/bin:$PATH"

# CUDA
export PATH="/usr/local/cuda-12.4/targets/x86_64-linux/lib:$PATH"
export PATH="/usr/local/cuda-12.4/bin/nvcc:$PATH"

# Aliases
alias gac="git add . && git commit"
alias merch="npm run management:api"

#Better npm install with bun :D
npm() {
	if [[ "$1" = "i" && "$#" -eq 1 ]]; then
		command bun install &&\
			rm bun.lock &&\
			contents="$(jq 'del(.trustedDependencies)' package.json)" &&\
			echo -E "${contents}" > package.json &&\
			npx prettier -w package.json &&\
			npm install
	else
		command npm "$@"
	fi
}

alias buni="npm i"
alias email="aerc"

export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/opt/nvim-linux64/bin"

if [[ -f ~/.pyenvrc ]]; then
	source ~/.pyenvrc
fi

# Map caps to esc
if [[ $XDG_SESSION_TYPE == "x11" ]]; then
	setxkbmap -option caps:escape
elif [[ -n "$DISPLAY" && -z "$TMUX" ]]; then
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
fi


# Set the browser to chrome for WSL
if [ -d "/proc/version" ]; then
	if [[ $(grep -i Microsoft /proc/version) ]]; then
		export BROWSER="/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
		gh config set browser "/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
	fi
fi

# Kamal Deployment Tool
alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "${SSH_AUTH_SOCK}:/ssh-agent" -v /var/run/docker.sock:/var/run/docker.sock -e "SSH_AUTH_SOCK=/ssh-agent" ghcr.io/basecamp/kamal:latest'

# Podman instead of Docker
alias docker='podman'
export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/podman.sock"
# Some issue with testcontainers and podman
export TESTCONTAINERS_RYUK_DISABLED=true

# Lazy-start podman machine + Background Containers tmux session (backgrounded — does not block shell startup)
# Add more containers as "Pane Name:command" pairs in the array below. Commands run with cwd = ~/docker.
{
    if [[ ! -S "$HOME/.local/share/containers/podman/machine/podman.sock" ]]; then
        podman machine list --format '{{.Name}}' | grep -q . || podman machine init
        podman machine start
    fi
    if ! tmux has-session -t="Background Containers" 2>/dev/null; then
        bg_containers=(
            "Postgres:./postgres.sh"
            "Redis:./redis.sh"
        )
        first=1
        for entry in "${bg_containers[@]}"; do
            name="${entry%%:*}"
            cmd="${entry#*:}"
            if (( first )); then
                tmux new-session -ds "Background Containers" -n "$name" -c "$HOME/docker"
                first=0
            else
                tmux new-window -t "Background Containers" -n "$name" -c "$HOME/docker"
            fi
            tmux send-keys -t "Background Containers:$name" "$cmd" Enter
        done
    fi
} >/dev/null 2>&1 &!

# TSGO
export PATH="$PATH:/home/dylan/repos/typescript-go/built/local"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dylan/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dylan/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dylan/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dylan/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export BP_DEV_HOME=/Users/dylan/repos/bindplane-op-enterprise
source "$BP_DEV_HOME/dev/aliases"

fpath=(~/.zsh_completions /Users/dylan/.zsh_completions /Users/dylan/.oh-my-zsh/plugins/git /Users/dylan/.oh-my-zsh/functions /Users/dylan/.oh-my-zsh/completions /Users/dylan/.oh-my-zsh/custom/functions /Users/dylan/.oh-my-zsh/custom/completions /Users/dylan/.oh-my-zsh/cache/completions /usr/local/share/zsh/site-functions /usr/share/zsh/site-functions /usr/share/zsh/5.9/functions)
autoload -Uz compinit
compinit -u

# opencode
export PATH=/Users/dylan/.opencode/bin:$PATH

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Splunk
export SPLUNK_HOME=/Applications/SplunkForwarder

# Go: auto-download the toolchain pinned in go.mod when it exceeds the installed version
export GOTOOLCHAIN=auto

# Check if we are in bindplane-op-enterprise repo and run make install
install_bindplane() {
	if [[ "$PWD" == *"bindplane-op-enterprise"* ]]; then
		make install
	fi
}
