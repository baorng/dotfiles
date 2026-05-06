# Personal dotfiles

Symlink-managed config source.

## Usage

```bash
./install
./install --dry-run
```

## Layout

- `home/` mirrors paths under `$HOME`.
- `install` links selected paths from `home/` into `$HOME`.
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
