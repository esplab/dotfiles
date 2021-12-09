# Dotfiles

Use GNU Stow to manage dotfiles

stow program-name
to install program's config files

stow */
to install config files for all programs under stow management
after this run the following for zsh plugins (zinit)

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
mkdir -p "$ZINIT_HOME"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"


That's it.

