# Enable startup debug time
# zmodload zsh/zprof
[ -f ~/secrets.sh ] && source ~/secrets.sh

# Mr Windows Defender hates nvim logs
export NVIM_LOG_FILE="/dev/null"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/custom-scripts:/usr/local/bin:$PATH

# ============================================================
# oh-my-zsh (only loaded if actually installed)
# ============================================================
export ZSH="$HOME/.oh-my-zsh"

if [ -d "$ZSH" ]; then
	# Add my custom completions, if present
	[ -d ~/.zsh_completions ] && fpath+=(~/.zsh_completions)

	autoload -Uz compinit
	compinit -u

	ZSH_THEME="robbyrussell"
	zstyle ':omz:update' mode auto

	plugins=(git)

	source "$ZSH/oh-my-zsh.sh"
else
	# Fallback completion so the shell isn't totally bare without oh-my-zsh
	autoload -Uz compinit && compinit -u
fi

# At the top of a worktree, show the root repo name instead of the long
# branch-derived dir name; the branch itself is already in the prompt.
_wt_prompt_path() {
	local top common
	top=$(command git rev-parse --show-toplevel 2>/dev/null)
	if [[ -n "$top" && "$top" == "$PWD" ]]; then
		common=$(command git rev-parse --git-common-dir 2>/dev/null)
		[[ -n "$common" ]] && { print -rn -- "${${common:A:h}:t}"; return }
	fi
	print -rn -- "${PWD:t}"
}

if (( $+functions[git_prompt_info] )); then
	PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}\$(_wt_prompt_path)%{$reset_color%}"
	PROMPT+=' $(git_prompt_info)'
fi

export REPOS="$HOME/git"

# Put gocache in git folder
mkdir -p ~/git/.cache/{go-build,go-mod,go-tmp}
export GOCACHE=$HOME/git/.cache/go-build
export GOMODCACHE=$HOME/git/.cache/go-mod
export GOTMPDIR=$HOME/git/.cache/go-tmp

# ============================================================
# User configuration
# ============================================================
command -v nvim >/dev/null 2>&1 && export EDITOR='nvim' || export EDITOR='vim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Only auto-attach tmux if tmux is installed, we're in an interactive
# shell, and we're not already inside tmux/screen
if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
	tmux attach 2>/dev/null || tmux
fi

# ============================================================
# bun
# ============================================================
if [ -d "$HOME/.bun" ]; then
	[ -s "$HOME/.bun/shell.zsh" ] && source "$HOME/.bun/shell.zsh"
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

# ============================================================
# go
# ============================================================
[ -d "/usr/local/go/bin" ] && export PATH="$PATH:/usr/local/go/bin"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"
export GOTOOLCHAIN=auto
[ -d "$REPOS/typescript-go/built/local" ] && export PATH="$PATH:$REPOS/typescript-go/built/local"

# ============================================================
# fnm (aliased as nvm) — only touched if fnm is actually installed
# ============================================================
[ -d "$HOME/.local/share/fnm" ] && export PATH="$HOME/.local/share/fnm:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"

if command -v fnm >/dev/null 2>&1; then
	eval "$(fnm env --use-on-cd --shell zsh)"
	alias nvm="fnm"
fi

# ============================================================
# Misc tool paths (each only added if it exists on this machine)
# ============================================================
[ -d "$HOME/.turso" ] && export PATH="$HOME/.turso:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -d "/opt/nvim" ] && export PATH="$PATH:/opt/nvim"
[ -d "/opt/nvim-linux64/bin" ] && export PATH="$PATH:/opt/nvim-linux64/bin"

[ -f ~/.pyenvrc ] && source ~/.pyenvrc

# CUDA (only if installed at this path)
if [ -d "/usr/local/cuda-12.4" ]; then
	[ -d "/usr/local/cuda-12.4/targets/x86_64-linux/lib" ] && \
		export LD_LIBRARY_PATH="/usr/local/cuda-12.4/targets/x86_64-linux/lib:$LD_LIBRARY_PATH"
	[ -d "/usr/local/cuda-12.4/bin" ] && export PATH="/usr/local/cuda-12.4/bin:$PATH"
fi

# Java (homebrew openjdk, macOS only)
[ -d "/opt/homebrew/opt/openjdk/bin" ] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Google Cloud SDK
[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ] && source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ] && source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"

# Splunk (only export if the install actually exists)
[ -d "/Applications/SplunkForwarder" ] && export SPLUNK_HOME=/Applications/SplunkForwarder

# ============================================================
# Aliases (guarded so they don't shadow missing commands)
# ============================================================
command -v git >/dev/null 2>&1 && alias gac="git add . && git commit"
alias merch="npm run management:api"
command -v aerc >/dev/null 2>&1 && alias email="aerc"

# Better npm install with bun :D — falls back to plain npm if any
# required tool (bun/jq/npx) is missing, so this is never a silent
# no-op or a hard failure on a machine without the full toolchain.
npm() {
	if [[ "$1" = "i" && "$#" -eq 1 ]] \
		&& command -v bun >/dev/null 2>&1 \
		&& command -v jq >/dev/null 2>&1 \
		&& command -v npx >/dev/null 2>&1; then
		command bun install &&\
			rm -f bun.lock &&\
			contents="$(jq 'del(.trustedDependencies)' package.json)" &&\
			echo -E "${contents}" > package.json &&\
			npx prettier -w package.json &&\
			command npm install
	else
		command npm "$@"
	fi
}
alias buni="npm i"

# Kamal Deployment Tool (alias is inert unless docker is installed/used)
command -v docker >/dev/null 2>&1 && alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "${SSH_AUTH_SOCK}:/ssh-agent" -v /var/run/docker.sock:/var/run/docker.sock -e "SSH_AUTH_SOCK=/ssh-agent" ghcr.io/basecamp/kamal:latest'

# Podman instead of Docker — only rewire "docker" if podman is actually
# installed, otherwise leave real docker (or nothing) alone.
if command -v podman >/dev/null 2>&1; then
	alias docker='podman'
	[ -S "$HOME/.local/share/containers/podman/machine/podman.sock" ] && \
		export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/podman.sock"
	export TESTCONTAINERS_RYUK_DISABLED=true
fi

# ============================================================
# Input / display tweaks
# ============================================================
# Map caps to esc — only if the relevant tool for this session type exists
if [[ $XDG_SESSION_TYPE == "x11" ]] && command -v setxkbmap >/dev/null 2>&1; then
	setxkbmap -option caps:escape
elif [[ -n "$DISPLAY" && -z "$TMUX" ]] && command -v gsettings >/dev/null 2>&1; then
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']" 2>/dev/null
fi

# Set the browser to chrome for WSL
# (checks the FILE /proc/version, not a directory — and checks the
# chrome path exists before wiring it up)
if [ -f "/proc/version" ] && grep -qi Microsoft /proc/version 2>/dev/null; then
	CHROME_WIN_PATH="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
	if [ -f "$CHROME_WIN_PATH" ]; then
		export BROWSER="${CHROME_WIN_PATH// /\\ }"
		command -v gh >/dev/null 2>&1 && gh config set browser "$BROWSER"
	fi
fi

# ============================================================
# Lazy-start podman machine + Background Containers tmux session
# Only runs if BOTH podman and tmux are installed. Backgrounded so it
# never blocks shell startup, and any failure inside is swallowed.
# Add more containers as "Pane Name:command" pairs in the array below.
# Commands run with cwd = ~/docker (only if that dir exists).
# ============================================================
if command -v podman >/dev/null 2>&1 && command -v tmux >/dev/null 2>&1 && [ -d "$HOME/docker" ]; then
{
    if [[ ! -S "$HOME/.local/share/containers/podman/machine/podman.sock" ]]; then
        podman machine list --format '{{.Name}}' 2>/dev/null | grep -q . || podman machine init
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
            # only wire up the pane if the referenced script actually exists
            [ -f "$HOME/docker/${cmd#./}" ] || continue
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
fi

# ============================================================
# Auto-start spotify_player tmux session
# ============================================================
if command -v tmux >/dev/null 2>&1 && command -v spotify_player >/dev/null 2>&1; then
{
    if ! tmux has-session -t="Spotify" 2>/dev/null; then
        tmux new-session -ds "Spotify" -c "$HOME"
        tmux send-keys -t "Spotify" "spotify_player" Enter
    fi
} >/dev/null 2>&1 &!
fi

# ============================================================
# bindplane-op-enterprise (fully optional — no-op if repo isn't present)
# ============================================================
export BP_DEV_HOME="$HOME/git/bindplane-op-enterprise"

[ -f "$BP_DEV_HOME/dev/aliases" ] && source "$BP_DEV_HOME/dev/aliases"

# Runs `make install` when your cwd is inside the bindplane repo AND
# `make` is available. Currently only callable manually; hook it to
# `cd` yourself if you want it automatic:
#   autoload -U add-zsh-hook
#   add-zsh-hook chpwd install_bindplane
install_bindplane() {
	if [[ "$PWD" == *"bindplane-op-enterprise"* ]] && command -v make >/dev/null 2>&1; then
		make install
	fi
}
