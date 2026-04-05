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
# mac
# ================================
if [[ "$PLATFORM" == "mac" ]]; then
  if ! command -v brew >/dev/null; then
    echo "===> install brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew install git tmux zsh fzf neovim zplug
fi

# ================================
# ubuntu
# ================================
if [[ "$PLATFORM" == "linux" ]]; then
  sudo apt update
  sudo apt install -y git tmux zsh fzf neovim curl build-essential

  # zplug
  if [[ ! -d "$HOME/.zplug" ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
  fi
fi

# ================================
# symlink
# ================================
DOT="$HOME/dotfiles"

ln -sf "$DOT/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOT/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOT/tmux/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"
ln -sf "$DOT/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# ================================
# zsh default
# ================================
if [[ "$SHELL" != *"zsh" ]]; then
  chsh -s "$(which zsh)"
fi

echo "✅ done"
echo "restart terminal"