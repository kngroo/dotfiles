#!/bin/bash

# Install ohmyzsh with the unattended flag: https://github.com/ohmyzsh/ohmyzsh?tab=readme-ov-file#unattended-install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
