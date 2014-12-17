## COLORS AND PROMPT
export CLICOLOR=1
PS1='\[\033[1;33m\]\W$(__git_ps1 " (%s)") \$ \[\033[0m\]'

## GIT COMPLETION AND PROMPT
if [ -f ~/.git-completion.sh ]; then
  source ~/.git-completion.sh
fi
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

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
