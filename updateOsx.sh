#!/usr/bin/env zsh

set -e

# xcode-command-line-tool
open 'https://developer.apple.com/download/all/?q=command%20line%20tools'

read -r -p "download finished and installed? [y/n] " response
case "$response" in 
    [yY] )
        brew update && brew outdated
        brew upgrade && brew cleanup
        ;;
    *)
        echo 'abort'
        ;;
esac
