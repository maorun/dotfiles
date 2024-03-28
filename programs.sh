#!/usr/bin/env zsh

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/mdriemel/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
# xcode-command-line-tool
open 'https://developer.apple.com/download/all/?q=command%20line%20tools'

# ssh-keygen -t rsa -b 4096 -C <email-Adresse> => in github eintragen
# ssh-add

brew install cask # now you can install applications such as phpstorm
brew install keepassxc alfred iterm2 sourcetree tunnelblick # here are the applications to install

# TODO break to configure keepassxc (to get ssh and alfred-key/alfred-profile)

curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

brew install stow npm jq yq
brew install terminal-notifier thefuck autojump watch htop howdoi # little helper
brew install fd nvim ctags tmux tmuxinator ripgrep luarocks # vim
brew install fzf obsidian google-drive
# TODO connect alfred with obsidian

brew install gpg gnupg pinentry-mac # git gpg-key mit keychain https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
# music: mps-youtube epv
brew install ffmpeg yt-dlp
brew install lua-language-server
brew install efm-langserver

brew install --cask spotify
brew install --cask imageoptim

curl https://get.volta.sh | bash
volta install node

# npm
npm install -g @tailwindcss/language-server graphql-language-service-cli intelephense neovim nodemon sonarqube-scanner typescript-language-server typescript sql-language-server vim-language-server
# eslint
npm install -g prettier prettier-eslint prettier-eslint-cli
npm i -g vscode-langservers-extracted

# ai
npm install -g aicommits opencommit # git-commit-messages

brew install pipx
pipx install openai
python3 -m pip install --user --upgrade pynvim --break-system-packages
luarocks install vusted

# TODO: if not exists
# git clone https://github.com/tom-doerr/zsh_codex.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh_codex # cli-completion

# add ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

# add zsh-plugins
# TODO: if not exists
# git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# change to zsh
chsh -s /bin/zsh

# TODO change config zsh
# General -> Closing -> disable all
# Profile -> General -> Title -> Name (Job) - User@Host>PWD - TTY
# Profile -> General -> Title -> Applications in terminal may change the title (disablen)
# Profile -> Terminal -> Notifications -> Silence bell
# Profile -> Terminal -> Enable mouse reporting (disablen)

brew install gh
gh completion -s zsh > ~/.oh-my-zsh/custom/github-completion.zsh

#
# Mac -> preferences > keyboard > Modifier Keys -> change capslock to command
# Mac -> preferences > Sound > Play sound on startup (disable)

git config --global --add url."git@github.com:".insteadOf "https://github.com/"

git submodule init
# here you need ssh
git submodule update

./activate_dotfiles

sh ./axelspringer/programs.sh
sh ./personal/programs.sh

# chrome anmeldung

# cp -r ~/.local/share/db_ui 
# cp ~/.local/share/nvim/maorun-time.json
# cp ~/.local/share/nvim/telescope*
# cp ~/Library/autojump/autojump.txt
# cp all .env
# outlook signature
