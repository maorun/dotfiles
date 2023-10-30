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
brew install terminal-notifier thefuck autojump watch htop howdoi # little helper
brew install fd nvim ctags tmux tmuxinator ripgrep # vim
brew install pinentry-mac # git gpg-key mit keychain https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
# music: mps-youtube epv
brew install ffmpeg yt-dlp
brew install lua-language-server

brew install --cask spotify
brew install --cask imageoptim

# npm
npm install -g @tailwindcss/language-server graphql-language-service-cli intelephense neovim nodemon sonarqube-scanner typescript-language-server typescript sql-language-server vim-language-server
# eslint
npm install -g prettier prettier-eslint prettier-eslint-cli
npm i -g vscode-langservers-extracted

# ai
npm install -g aicommits opencommit # git-commit-messages
pip3 install openai && git clone https://github.com/tom-doerr/zsh_codex.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh_codex # cli-completion


# add ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

# add zsh-plugins
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# change to zsh
chsh -s /bin/zsh

brew install gh
gh completion -s zsh > ~/.oh-my-zsh/custom/github-completion.zsh

curl https://get.volta.sh | bash
