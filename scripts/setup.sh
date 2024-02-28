brew_install() { # Installs brew using the install script
  which -s brew
  if [[ $? != 0 ]]; then
    echo Installing Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo Homebrew exists, skipping installation
  fi
}

nvm_install() {
  echo Installing nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
}

echo Running setup script!

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew_install
  nvm_install
fi
