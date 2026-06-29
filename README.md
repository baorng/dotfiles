# Personal dotfiles

Symlink-managed config source, plus a one-command machine bootstrap.

## Bootstrap a fresh machine

Provision a clean Debian/Ubuntu VPS and link these dotfiles. Run as root;
idempotent.

```bash
apt update && apt install -y git
git clone https://github.com/baorng/dotfiles
./dotfiles/bootstrap-debian <username>      # --dry-run to preview
```

Creates a key-only `<username>` with passwordless sudo, hardens SSH/firewall,
adds swap, and installs the Homebrew toolbelt (`Brewfile`). Login shell stays
bash; interactive sessions hand off to fish. Test `ssh <username>@host` before
closing the root session.

## Usage

```bash
./install
./install --dry-run
```

## Layout

- `home/` mirrors paths under `$HOME`.
- `install` links selected paths from `home/` into `$HOME`.
- `bootstrap-debian` provisions a fresh Debian/Ubuntu machine, then runs `install`.
- `Brewfile` lists the Homebrew toolbelt that `bootstrap-debian` installs.
- `.backups/` stores live paths that were replaced by `install`.

## Chezmoi archive

This repository previously used chezmoi. The archived chezmoi version is preserved at:

- branch: `archive/chezmoi-2026-05-07`
- tag: `chezmoi-archive-2026-05-07`

The active system is now the symlink-based installer on `main`.

## Managed paths

| Source | Link |
|---|---|
| `home/.config/fish` | `~/.config/fish` |
| `home/.config/ghostty` | `~/.config/ghostty` |
| `home/.config/yazi` | `~/.config/yazi` |
| `home/.glzr` | `~/.glzr` |
