## COLORS AND PROMPT
export CLICOLOR=1
PS1='\[\033[1;33m\]\W$(__git_ps1 " (%s)") \$ \[\033[0m\]'

## PROFILE SOURCING
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

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

## RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH
