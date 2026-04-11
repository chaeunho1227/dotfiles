#!/usr/bin/env bash
set -e

echo "===> OS detect"
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  PLATFORM="mac"
elif [[ "$OS" == "Linux" ]]; then
  PLATFORM="linux"
else
  echo "Unsupported OS"
  exit 1
fi

# ================================
# dotfiles 경로 자동 감지
# ================================
DOT="$(cd "$(dirname "$0")" && pwd)"

# ================================
# Homebrew 설치
# ================================
if [[ "$PLATFORM" == "mac" ]]; then
  if ! command -v brew >/dev/null; then
    echo "===> install Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

elif [[ "$PLATFORM" == "linux" ]]; then
  sudo apt update
  sudo apt install -y build-essential procps curl file git

  if ! command -v brew >/dev/null; then
    echo "===> install Linuxbrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ================================
# 공통 패키지 (brew)
# ================================
brew install git tmux zsh fzf neovim zplug

# ================================
# symlink
# ================================
ln -sf "$DOT/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOT/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOT/tmux/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"
ln -sf "$DOT/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# ================================
# TPM (tmux plugin manager)
# ================================
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "===> install TPM"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ================================
# zsh default shell
# ================================
if [[ "$SHELL" != *"zsh" ]]; then
  chsh -s "$(which zsh)"
fi

echo "done"
echo "restart terminal"
