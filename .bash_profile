# Terminal prompt
export CLICOLOR=1
PS1='\[\033[1;33m\]\W$(__git_ps1 " (%s)")\[\033[0m\]\[\033[0;30m\] 𝄢 \[\033[0m\]'

# Profile sourcing
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# Git completion & prompt
if [ -f ~/.git-completion.sh ]; then
  source ~/.git-completion.sh
fi
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

# Bookmarks (e.g., `cd ~/Code/my-project/; m proj; cd ~; j proj`)
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

# Add my private key to the ssh agent
ssh-add ~/.ssh/id_rsa

# Programming language version & path managers
## Generic path-ification
export PATH="/Users/dkettler/.local/bin:$PATH"

## Ruby (rvm)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

## Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Node (nvm)
export NVM_DIR="/Users/dkettler/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
