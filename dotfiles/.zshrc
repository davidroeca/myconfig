#############################################################
# David's zshrc file |
#---------------------
# Edit paths {{{
path_ladd () {
  # Takes 1 argument and adds it to the beginning of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

path_radd () {
  # Takes 1 argument and adds it to the end of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

############################################################
# Define preferred editor
############################################################
# TODO: use nvim for pager at some point
export MANPAGER=less
if [ -x "$(command -v nvim)" ]
then
  export EDITOR=nvim
elif [ -x "$(command -v vim)" ]
then
  export EDITOR=vim
else
  export EDITOR=vi
fi

############################################################
# Set React environment variables
############################################################
export REACT_EDITOR=$EDITOR

############################################################
# Modify path
############################################################

POETRY_PATH="$HOME/.poetry/bin"
if [ -d "$POETRY_PATH" ]
then
  path_radd $POETRY_PATH
fi


CARGO_BIN="$HOME/.cargo/bin"
if [ -d "$CARGO_BIN" ]
then
  path_ladd "$CARGO_BIN"
fi

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]
then
  path_ladd "$HOME_BIN" # Personal binary files
fi

if rustc_loc="$(type -p "rustc")" && [[ ! -z $rustc_loc ]]
then
  RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src
  if [ -d $RUST_SRC_PATH ]
  then
    export RUST_SRC_PATH
  else
    echo "$RUST_SRC_PATH does not exist."
    echo "Run 'rustup component add rust-src' to fix"
  fi
fi

GOPATH="$HOME/go"
if [ -d $GOPATH ]
then
  export GOPATH
fi

export PATH

# }}}
# zsh cache directory {{{
ZSH_CACHE_DIR=$HOME/.zsh_cache
if [ ! -e "$ZSH_CACHE_DIR" ]; then
  mkdir $ZSH_CACHE_DIR
fi
# }}}
# Turn off zsh corrections {{{
DISABLE_CORRECTION="true"
unsetopt correct
unsetopt correct_all

# }}}
# Miscellaneous {{{
# recognizes comments in shell
setopt interactivecomments
# if you type dir name and it's not a command, cd to the dir
setopt auto_cd
# }}}
# History settings {{{
setopt append_history
# }}}
# ls settings {{{
if [[ "$OSTYPE" == darwin* ]]
then
  # This should work fine for OSX
  ls -G . &>/dev/null && alias ls='ls -G'
else
  if [[ -z "$LS_COLORS" ]]
  then
    (( $+commands[dircolors] )) && eval "$(dircolors -b)"
  fi
  ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G &>/dev/null && alias ls='ls -G' }
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
# }}}
# Custom sourcing {{{
include () {
  [[ -f "$1" ]] && source "$1"
}
include ~/.shrc_local
include ~/.bash/sensitive
# }}}
# Custom aliases/sources {{{

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias f='nvim'

alias vn='python3 -m venv venv'
alias va='source venv/bin/activate'

alias tmux='tmux -2'
alias tn='tmux new-session \; rename-window "Source Code"'
alias tl='tmux ls'
alias ta='tmux attach -t'
alias tk='tmux kill-session -t'

alias -g ...='../../'
alias -g ....='../../'
alias -g .....='../../../../'
alias -g ......='../../../../../'
alias -g .......='../../../../../../'
alias -g ........='../../../../../../../'
alias -g .........='../../../../../../../../'

# }}}
# Custom external completions {{{
if [ -d ~/.zfunc ]
then
  fpath+=~/.zfunc
fi
# }}}
# custom completions {{{

# Python compiled files
zstyle ":completion:*" ignored-patterns "(*/)#(__pycache__|*.pyc|node_modules|.git)"

# }}}
# opam configuration {{{
test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# }}}
# Run compinit {{{
# zplug runs compinit for us; no need to use it
# }}}
# plugins {{{
export ZPLUG_HOME="$HOME/.zplug"
if [ -f $ZPLUG_HOME/init.zsh ]
then
  source $ZPLUG_HOME/init.zsh
  zplug "lib/clipboard", from:oh-my-zsh
  # Handle completion from oh-my-zsh
  zplug "lib/completion", from:oh-my-zsh
  # Hitting up arrow key gives most recent hist command
  zplug "lib/key-bindings", from:oh-my-zsh
  zplug "lib/history", from:oh-my-zsh
  zplug "mafredri/zsh-async", from:github
  zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug "docker/compose", use:"contrib/completion/zsh", as:plugin
  # If this command is doing weird stuff, you can add the --verbose flag
  if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
  fi

  # Then, source plugins and add commands to $PATH
  # If this command is doing weird stuff, you can add the --verbose flag
  zplug load --verbose
else
  echo "------------------------------------------------------------"
  echo "Please install zplug with the following command:"
  echo ""
  echo "git clone https://github.com/zplug/zplug ${ZPLUG_HOME}"
  echo "------------------------------------------------------------"
fi

# }}}
# asdf includes {{{
include ~/.asdf/asdf.sh
include ~/.asdf/completions/asdf.bash
# }}}
