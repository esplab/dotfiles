typeset -U PATH path

export GOROOT=/usr/lib/go
export GOPATH=$HOME/go

export ANDROID_HOME=$HOME/Android/Sdk

path=("$HOME/.local/bin" "$HOME/bin" "$HOME/bin/go/bin" "$path[@]" "$HOME/.composer/vendor/bin"  "$HOME/.cargo/bin" "/opt/flutter/bin" "$ANDROID_HOME/platform-tools")
export PATH
