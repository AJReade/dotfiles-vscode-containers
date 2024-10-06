# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/bin/fzf* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/share/doc/fzf/examples/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/share/doc/fzf/examples/key-bindings.zsh"
