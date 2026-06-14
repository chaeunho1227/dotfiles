# ================================
# Load private config (DO NOT COMMIT)
# ================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local


# ================================
# OS Detection
# ================================
OS_TYPE=""
case "$OSTYPE" in
  darwin*)  OS_TYPE="mac" ;;
  linux-gnu*) OS_TYPE="linux" ;;
esac


# ================================
# History
# ================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INC_APPEND_HISTORY EXTENDED_HISTORY


# ================================
# Instant prompt (Powerlevel10k)
# ================================
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ================================
# Homebrew (mac / optional linux)
# ================================
if [[ "$OS_TYPE" == "mac" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OS_TYPE" == "linux" ]]; then
  if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi


# ================================
# PATH
# ================================
export PATH="$HOME/.local/bin:$PATH"


# ================================
# Aliases
# ================================
if [[ -d "$HOME/Documents/Workspace" ]]; then
  alias work="cd ~/Documents/Workspace"
fi

# Obsidian (mac only)
if [[ "$OS_TYPE" == "mac" && -n "$OBSIDIAN_DIR" ]]; then
  alias obsi="cd $OBSIDIAN_DIR"
fi

# Tailscale (mac: 앱 번들 경로 / linux: 시스템 CLI)
if [[ "$OS_TYPE" == "mac" ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi
alias tdget='tailscale file get ~/Downloads/'   # Taildrop 받은 파일 수령 (맥/우분투 공통)


# ================================
# Zplug (Plugin Manager)
# ================================
if command -v brew >/dev/null 2>&1; then
  export ZPLUG_HOME=$(brew --prefix zplug)
elif [[ -d "$HOME/.zplug" ]]; then
  export ZPLUG_HOME="$HOME/.zplug"
fi

if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
  source $ZPLUG_HOME/init.zsh

  # Theme
  zplug romkatv/powerlevel10k, as:theme, depth:1

  # Plugins
  zplug "plugins/git", from:oh-my-zsh
  zplug "plugins/yarn", from:oh-my-zsh

  # Install if missing
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo
      zplug install
    fi
  fi

  zplug load
fi


# ================================
# Completion (플러그인 fpath 반영 후 초기화)
# ================================
autoload -Uz compinit && compinit -C


# ================================
# fzf
# ================================
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi


# ================================
# Powerlevel10k config
# ================================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# ================================
# Claude aliases
# ================================
alias cc='claude --continue'
alias cr='claude --resume'

claude() {
  local args=()
  for arg in "$@"; do
    if [[ "$arg" == "--fs" ]]; then
      args+=("--fork-session")
    else
      args+=("$arg")
    fi
  done
  command claude "${args[@]}"
}


# ================================
# pyenv (설치돼 있을 때만 — pyenv 없는 머신에서 에러 방지)
# ================================
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
fi
