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

# add my private key to the ssh agent
ssh-add ~/.ssh/id_rsa

# Treat non-alphanumeric characters as word breaks for word-dependent tools (e.g., alt+backspace)
autoload -U select-word-style
select-word-style bash
