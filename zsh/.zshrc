# User-local Zsh setup. This intentionally does not use Oh My Zsh.

export PATH="$HOME/.local/bin:$PATH"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt auto_cd
setopt interactive_comments

autoload -Uz compinit
zmodload zsh/complist
compinit

zstyle ':completion:*' menu select=1
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' select-prompt '%SScrolling active: current match %p%s'

bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char
bindkey '^I' menu-select

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza --icons=auto --group-directories-first --long --git'
  alias la='eza --icons=auto --group-directories-first --long --all --git'
  alias tree='eza --icons=auto --group-directories-first --tree'
fi

if command -v fzf >/dev/null 2>&1; then
  FZF_BIN="$(command -v fzf)"
  FZF_BASE="${FZF_BASE:-${FZF_BIN:h:h}/share/fzf}"
  export FZF_COMPLETION_TRIGGER='**'
  if [[ -t 0 && -t 1 && -r "$FZF_BASE/shell/completion.zsh" && -r "$FZF_BASE/shell/key-bindings.zsh" ]]; then
    source "$FZF_BASE/shell/completion.zsh"
    source "$FZF_BASE/shell/key-bindings.zsh"
    bindkey '^G' fzf-cd-widget
    _fzf_or_menu_select() {
      local trigger="${FZF_COMPLETION_TRIGGER-'**'}"
      if [[ -n "$trigger" && "$LBUFFER" == *"$trigger" ]]; then
        zle fzf-completion
      else
        zle menu-select
      fi
    }
    zle -N _fzf_or_menu_select
    bindkey '^I' _fzf_or_menu_select
  fi
  unset FZF_BIN
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

ZSH_PLUGIN_DIR="${ZSH_PLUGIN_DIR:-$HOME/.local/share/zsh/plugins}"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'
if [[ -r "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [[ -r "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if [[ -z "$CONDA_ROOT" ]]; then
  if command -v conda >/dev/null 2>&1; then
    CONDA_ROOT="$(conda info --base 2>/dev/null)"
  else
    CONDA_ROOT="$HOME/miniforge3"
  fi
fi

if [[ -x "$CONDA_ROOT/bin/conda" ]]; then
  __conda_setup="$("$CONDA_ROOT/bin/conda" shell.zsh hook 2>/dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$__conda_setup"
  elif [[ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]]; then
    . "$CONDA_ROOT/etc/profile.d/conda.sh"
  else
    export PATH="$CONDA_ROOT/bin:$PATH"
  fi
  unset __conda_setup
fi
