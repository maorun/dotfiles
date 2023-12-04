# alias ta="tmux attach-session"

 alias weather='curl "wttr.in/Hamburg?1&lang=de"'

 alias lls='ls -latr'
alias t='tmux'

alias nv='nvim'
alias vi='nvim'
alias vim='nvim'

alias fp='fzf-pnpm'
alias fk='fzf-k8s'
alias fn='fzf-npm'

alias wo="watch timeOverview"

alias update='pnpm add -g pnpm && npm install -g npm && brew update && brew upgrade'

alias gsl='git stash list | fzf-tmux -p80%,60% -- \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --border-label-pos=2 \
    --color="header:italic:underline,label:blue" \
    --preview-window="right,50%,border-left" \
    --bind="ctrl-/:change-preview-window(down,50%,border-top|hidden|)" \
    --border-label "<0001f961> Stashes" \
    --header $"CTRL-X (drop stash)\n\n" \
    --bind "ctrl-x:execute-silent(git stash drop {1})+reload(git stash list)" \
    --bind "ctrl-f:preview-page-down,ctrl-u:preview-page-up" -d: --preview "git show --color=always {1}" "$@" |
  cut -d: -f1'
