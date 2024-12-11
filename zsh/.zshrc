# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


# Prevent Ctrl+D from closing terminal
setopt IGNOREEOF


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  # zsh-syntax-highlighting
  zsh-autosuggestions
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# prevent CTRL Z from zapping my window
bindkey '^Z' clear-screen  # This rebinds Ctrl+Z to just clear the screen


# Load FZF 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste up-line-or-search down-line-or-search expand-or-complete accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_STRATEGY=(history)

# Make Tab and ShiftTab cycle completions on the command line
# bindkey              '^I'         menu-complete
# bindkey "$terminfo[kcbt]" reverse-menu-complete
# makes enter always submit the command line, even when you are in the menu
bindkey -M menuselect '^M' .accept-line
bindkey '^I' autosuggest-accept


#replace the travis@macbookpro part of the prompts
prompt_context(){}


# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify


# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


# ---- Eza (better ls) -----

alias ls="eza --icons=always"


# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"

# hitting escape then c was causing some fzf widget to come up
bindkey -r '^[c'
bindkey -r '\ec'

# Custom FZF keybindings
# Custom FZF keybindings
bindkey -M emacs '\C-d' fzf-cd-widget      # Ctrl+D for directory search
bindkey -M emacs '\C-f' fzf-file-widget    # Ctrl+F for file search
# bindkey '^D' fzf-cd-widget      # Ctrl+D for directory search
# bindkey '^F' fzf-file-widget    # Ctrl+F for file search
# activate nvim on the current line selected with Ctrl V for vim
FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute(nvim {})'"

