git config --global color.pager no
git config --global core.pager nvimpager

zstyle ':completion:*' menu select

autoload -Uz compinit 
compinit

# Enable cursor 
setterm -cursor on

termux=`echo "$PREFIX" | grep -o "com.termux"`

#  Completion for kitty
if [ ! $termux ]
then
  [ ! -f /etc/debian_version ] && kitty + complete setup zsh | source /dev/stdin
fi

# Disable flow control (ctrl+s, ctrl+q) to enable saving with ctrl+s in Vim
stty -ixon -ixoff

# Fix for starship prompt
if type 'prompt' 2>/dev/null | grep -q 'function'
then
   prompt off
fi

# Load starship prompt
eval "$(starship init zsh)"

sources=(
		  "$HOME/.zfunctions"
		  "$HOME/.zalias"
		  "$HOME/bin/fzf/completion.zsh" 
		  "$HOME/bin/fzf/fzf-extras.zsh" 
		  "$HOME/bin/fzf/key-bindings.zsh" 
		  "/usr/share/doc/pkgfile/command-not-found.zsh"
		  "$HOME/.zinit"
		  "$HOME/.zkeys"
)

for s in ${sources[@]}; do
 if [[ -r "$s" ]]; then
   source "$s"
 fi
done

if [ "$TERM_PROGRAM" != "vscode" ]; then
  if [ $termux  ]; then
   # neofetch
    fortune #-a   # other stuff
  else
	fortune -a
  fi
fi


lfcd () {
    tmp="$(m"git clone"ktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# unset zle_bracketed_paste
zle_highlight=('paste:none')

# pnpm
export PNPM_HOME="/home/esp/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

TMOUT=4800

TRAPALRM() { cmatrix -s -B }

[ ! -f /etc/debian_version ] && source /home/esp/.config/broot/launcher/bash/br
