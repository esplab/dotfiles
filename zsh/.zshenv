setopt extendedhistory histexpiredupsfirst histfindnodups histignoredups histignorespace histsavenodups histverify sharehistory

export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTFILE=~/.zsh_history

export PAGER=nvimpager
export MANPAGER=nvimpager
export EDITOR=nvim

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_ALT_C_COMMAND="cat $HOME/.cd_history"
export FZF_DEFAULT_OPTS='--prompt=❯❯\  --marker=✓\  --pointer=→ --color=16'
#export FZF_DEFAULT_COMMAND="fd"
# CTRL-T's command
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# ALT-C's command
#export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export GOROOT=/usr/lib/go
export GOPATH=$HOME/.go

export ANDROID_HOME=$HOME/Android/Sdk

typeset -U PATH path

path=("$HOME/.local/bin" "$HOME/bin" "$HOME/.go/bin" "$HOME/.composer/vendor/bin"  "$HOME/.cargo/bin" "/opt/flutter/bin" "$ANDROID_HOME/platform-tools" "$path[@]")
export PATH
