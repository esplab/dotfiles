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

git config --global color.pager no
git config --global core.pager nvimpager

zstyle ':completion:*' menu select

if type 'prompt' 2>/dev/null | grep -q 'function'
then
   prompt off
fi

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# Disable flow control (ctrl+s, ctrl+q) to enable saving with ctrl+s in Vim
stty -ixon -ixoff

eval "$(starship init zsh)"

autoload -Uz compinit promptinit
compinit
promptinit

sources=(
        "$HOME/.zfunctions"
		  "$HOME/.zalias"
		  "/usr/share/cdhist/cdhist.rc" 
		  "/usr/share/fzf/completion.zsh" 
		  "/usr/share/fzf/fzf-extras.zsh" 
		  "/usr/share/fzf/key-bindings.zsh" 
		  "/usr/share/doc/pkgfile/command-not-found.zsh"
		  "$HOME/.zinitrc"
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
