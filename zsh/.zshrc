git config --global color.pager no
git config --global core.pager nvimpager

zstyle ':completion:*' menu select

autoload -Uz compinit 
compinit

# Enable cursor 
setterm -cursor on

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

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
		  "/usr/share/cdhist/cdhist.rc" 
		  "/usr/share/fzf/completion.zsh" 
		  "/usr/share/fzf/fzf-extras.zsh" 
		  "/usr/share/fzf/key-bindings.zsh" 
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
#  neofetch
  fortune -a   # other stuff
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
