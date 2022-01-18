#!/usr/bin/env zsh

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# xcode-command-line-tool
open 'https://developer.apple.com/download/all/?q=command%20line%20tools'

# ssh-key-gen => in github eintragen
# ssh-add

brew install cask # now you can install applications such as phpstorm
brew install alfred iterm2 sourcetree tunnelblick # here are the applications to install

curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

brew install stow
brew install thefuck autojump watch htop # little helper
brew install fd nvim ctags tmux tmuxinator ripgrep # vim
brew install pinentry-mac # git gpg-key mit keychain https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
# music: youtube-dl mps-youtube epv

brew install --cask spotify
brew install --cask imageoptim

# add ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

# add zsh-plugins
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# change to zsh
chsh -s /bin/zsh

brew install gh
gh completion -s zsh > ~/.oh-my-zsh/custom/github-completion.zsh
