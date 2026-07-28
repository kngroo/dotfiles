#!/bin/bash

LOCAL_REPO=~/Development/dotfiles

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

brew_install() { # Installs brew using the install script
  if ! command_exists brew; then
    echo Installing Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo Homebrew exists, skipping installation
  fi
}

echo Running install script!

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew_install
  echo Cloning dotfiles repo from git
  mkdir -p $LOCAL_REPO
  git clone https://github.com/kngroo/dotfiles $LOCAL_REPO
  cd $LOCAL_REPO
fi
