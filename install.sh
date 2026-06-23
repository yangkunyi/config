#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
timestamp="$(date +%Y%m%d-%H%M%S)"

link_file() {
  local source_path="$1"
  local target_path="$2"
  local target_dir

  target_dir="$(dirname "$target_path")"
  mkdir -p "$target_dir"

  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    printf 'unchanged: %s -> %s\n' "$target_path" "$source_path"
    return
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    mv "$target_path" "$target_path.backup.$timestamp"
    printf 'backup: %s -> %s.backup.%s\n' "$target_path" "$target_path" "$timestamp"
  fi

  ln -s "$source_path" "$target_path"
  printf 'linked: %s -> %s\n' "$target_path" "$source_path"
}

link_file "$repo_root/zsh/.zshrc" "$HOME/.zshrc"
link_file "$repo_root/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$repo_root/starship/.config/starship.toml" "$HOME/.config/starship.toml"
link_file "$repo_root/conda/.condarc" "$HOME/.condarc"
link_file "$repo_root/yazi/.config/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
link_file "$repo_root/yazi/.config/yazi/package.toml" "$HOME/.config/yazi/package.toml"
link_file "$repo_root/yazi/.local/bin/yazi-localplay" "$HOME/.local/bin/yazi-localplay"
