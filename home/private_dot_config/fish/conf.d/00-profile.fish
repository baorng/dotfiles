# Ensure your critical universals exist
set -qg XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -qg XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -qg XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

# Favor globals for most things
set -gx EDITOR nvim
set -gx VISUAL code

# Paths
fish_add_path -g ~/.local/bin

