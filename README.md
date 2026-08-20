# devcontainer-dotfiles

Minimal dotfiles for **VS Code Remote Containers** and **GitHub Codespaces** —
NOT for macOS local dev. My real machine dotfiles live in a separate private
repo (`AJReade/dotfiles`).

## What this is for

VS Code has a setting `dotfiles.repository` (also honored by GitHub Codespaces
via user settings) that clones a **public** git repo into every devcontainer /
Codespace you open, then runs a bootstrap script. This repo is that.

Because it's public, it must not contain any secrets. Because it's for
ephemeral Linux containers (Debian/Ubuntu apt-get), it deliberately does NOT
include:
- macOS-specific PATH junk (Homebrew, `/opt/homebrew`, etc.)
- Anything asdf/mise/language-manager related — devcontainers ship their own
  toolchain via features
- Any personal aliases / secrets

## How VS Code uses it

Set once in your VS Code user settings:

```json
"dotfiles.repository": "AJReade/devcontainer-dotfiles",
"dotfiles.targetPath": "~/dotfiles",
"dotfiles.installCommand": "~/dotfiles/scripts/install.sh"
```

On every devcontainer/Codespace open, VS Code:
1. Clones this repo to `~/dotfiles` inside the container.
2. Runs `scripts/install.sh`, which:
   - `apt-get install`s `fd-find`, `fzf`, `p7zip-full`, `tree`, `vim`
   - Symlinks each config file (`.zshrc`, `.vimrc`, `.gitconfig`, `.fzf.zsh`)
     from `~/dotfiles/` to `$HOME/`.

## What's in it

| File | Purpose |
|---|---|
| `.zshrc` | Basic oh-my-zsh setup, aliases, fzf keybindings |
| `.vimrc` | Vim config |
| `.gitconfig` | Git identity + defaults |
| `.fzf.zsh` | fzf zsh bindings |
| `scripts/install.sh` | Bootstrap installer VS Code invokes |

## Not to be confused with

- **`AJReade/dotfiles`** (private) — my actual macOS dotfiles, way more
  extensive, managed via my main setup.
- **`AJReade/config-coding-setup`** (deleted 2026-08) — older iteration,
  retired.
