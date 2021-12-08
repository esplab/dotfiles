
### end of usefull functions

#setopt histignorespace           # skip cmds w/ leading space from history

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

sources=(
          "$HOME/.zfunctions"
		  "$HOME/.zalias"
		  "/usr/share/cdhist/cdhist.rc" 
		  "/usr/share/fzf/completion.zsh" 
		  "/usr/share/fzf/fzf-extras.zsh" 
		  "/usr/share/fzf/key-bindings.zsh" 
		  "/usr/share/doc/pkgfile/command-not-found.zsh"
)

for s in ${sources[@]}; do
 if [[ -r "$s" ]]; then
   source "$s"
 fi
done

# To make starship work edit /etc/zsh/zshrc and comment PS1 lines
# no need to edit /etc/zsh/zshrc the prompt off fixes the problem

#prompt off

if type 'prompt' 2>/dev/null | grep -q 'function'
then
   prompt off
fi

eval "$(starship init zsh)"

if [ "$TERM_PROGRAM" != "vscode" ]; then
#  neofetch
  fortune -a   # other stuff
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit compinit promptinit
(( ${+_comps} )) && _comps[zinit]=_zinit
compinit
promptinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust\
    zdharma-continuum/fast-syntax-highlighting

zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light urbainvaes/fzf-marks
zinit light wfxr/forgit
zinit light soimort/translate-shell
### end of extra plugins

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

### key definitions

bindkey '\e[1~' beginning-of-line
bindkey '\e[H' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[F' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[3~' delete-char

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -s '^[o' 'ranger^M'

### end of key definitions

# Disable flow control (ctrl+s, ctrl+q) to enable saving with ctrl+s in Vim
stty -ixon -ixoff
