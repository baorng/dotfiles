## Scope

This repo is `~/src/dotfiles`. It manages live dotfiles by symlinking paths from `home/` into `$HOME` with the `install` script.

## Rules

- Do not modify unrelated repos, especially `~/.local/share/chezmoi`, unless explicitly instructed.
- Do not edit Hermes source, bundled skills, or runtime config unless explicitly instructed.
- Keep the installer small, boring, and dependency-free. Bash is preferred for symlink orchestration.
- Use `home/` as a mirror of `$HOME` only for explicitly managed paths.
- Prefer folder-level symlinks for app config directories and file-level symlinks for single config files.
- Do not commit secrets, tokens, machine-local logs, `node_modules`, caches, or generated runtime state.
- Before deleting or replacing live paths, verify what is symlinked and preserve backups when needed.
- After changes, verify `~/<path>` points to `~/src/dotfiles/home/<path>` and check `git status`.
- When managed paths change, update `README.md`; do not duplicate the managed path inventory here.
