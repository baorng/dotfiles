# Bao's dotfiles

Live symlink-managed config source.

## Usage

```bash
./install
./install --dry-run
```

## Layout

- `home/` mirrors paths under `$HOME`.
- `install` links selected paths from `home/` into `$HOME`.
- `.backups/` stores live paths that were replaced by `install`.

## Managed paths

| Source | Link |
|---|---|
| `home/.config/fish` | `~/.config/fish` |
| `home/.config/ghostty` | `~/.config/ghostty` |
| `home/.config/yazi` | `~/.config/yazi` |
| `home/.glzr` | `~/.glzr` |
