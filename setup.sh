

brew_install()  # Installs brew using the install script
{
  which -s brew
  if [[ $? != 0 ]]
  then
    echo Installing Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo Homebrew exists, skipping installation
  fi
}

echo Running setup script!

if [[ "$OSTYPE" == "darwin"* ]]
then
  brew_install
fi
