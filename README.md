# Terminal Config

Portable terminal dotfiles for the active zsh setup.

## Contents

- `zsh/.zshrc`: zsh completion, fzf, zoxide, eza aliases, Starship, zsh plugins, and conda setup.
- `tmux/.tmux.conf`: mouse support and truecolor.
- `starship/.config/starship.toml`: Tokyo Night prompt with Nerd Font symbols.
- `conda/.condarc`: conda-forge channels and `changeps1: false`.
- `alist/README.md`: user-level AList install and tmux service notes.
- `install.sh`: backs up existing files and symlinks these configs into `$HOME`.

## Expected Tools

The shell config assumes these tools are available on `PATH` when you want their features:

- `zsh`
- `tmux`
- `starship`
- `fzf`
- `zoxide`
- `eza`
- `conda`

The current setup installs these through a conda environment named `shell-tools`, but the dotfiles do not require that exact path.

Recommended package set:

```sh
conda create -n shell-tools -c conda-forge zsh starship fzf zoxide eza
```

Expose them through `~/.local/bin` or activate the environment before launching zsh.

## Zsh Plugins

The zsh config looks for plugins under:

```text
~/.local/share/zsh/plugins
```

Install them with:

```sh
mkdir -p ~/.local/share/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/plugins/zsh-syntax-highlighting
```

## Conda

Set `CONDA_ROOT` if conda is not discoverable on `PATH` and is not installed at `~/miniforge3`:

```sh
export CONDA_ROOT=/path/to/miniforge3
```

## Install

Run:

```sh
./install.sh
```

Existing files are moved to timestamped backups before symlinks are created.

## Notes

- fzf completion uses the standard `**<Tab>` trigger.
- Plain `Tab` uses zsh menu selection directly.
- `Ctrl-G` opens fzf directory selection.
- Starship shows directory/git/tmux/duration/status on the left, and conda/time on the right.
- tmux truecolor is enabled with `tmux-256color` and `*:RGB`.
