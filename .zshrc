## COLORS AND PROMPT
export CLICOLOR=1

# Load version control information
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:git:*' patch-format '%n/%a'
zstyle ':vcs_info:git:*' actionformats ' (%b) [%a %m]'
setopt prompt_subst

# Assemble the prompt
PS1='%B%F{yellow}%c${vcs_info_msg_0_}%b%F{black} 𝄢 %f'

# Git autocomplete
autoload -Uz compinit && compinit

## BOOKMARKS
export MARKPATH=$HOME/.marks
function jump {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
  rm -i "$MARKPATH/$1"
}
function marks {
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
function j {
  jump $1
}
function m {
  mark $1
}

## Aliases
alias gitx='open -a GitX .'

# Docker
# Kill all running containers.
alias docker_kill='docker kill $(docker ps -q)'
# Delete all stopped containers.
alias docker_delete_stopped='docker rm $(docker ps -a -q)'
# Delete all untagged images.
alias docker_clean_dangling='docker rmi $(docker images -q -f dangling=true)'
# Halway to nuke
alias docker_soft_nuke='docker_kill; docker_delete_stopped; docker_clean_dangling;'
# Delete all images
alias docker_delete_images='docker rmi --force $(docker images -q)'
# Clean up file system data
alias docker_prune='docker system prune -f'
# Run all docker cleanup commands
alias docker_nuke='docker_kill; docker_delete_stopped; docker_clean_dangling; docker_delete_images; docker_prune'

# Calm aliases
alias api_dev='npm run test:env:down && npm run dev:env && npm run dev:apps'
alias web_dev='rush purge && rush update && rush login && rush build -v && rush lint -v && rush test -v'

## Path setup
# Node
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# add my private key to the ssh agent
# ssh-add -K ~/.ssh/id_rsa

# Treat non-alphanumeric characters as word breaks for word-dependent tools (e.g., alt+backspace)
autoload -U select-word-style
select-word-style bash

# bash parameter completion for the Rush CLI
_rush_bash_complete()
{
  local word=${COMP_WORDS[COMP_CWORD]}

  local completions
  completions="$(rush tab-complete --position "${COMP_POINT}" --word "${COMP_LINE}" 2>/dev/null)"
  if [ $? -ne 0 ]; then
    completions=""
  fi

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}
complete -f -F _rush_bash_complete rush
