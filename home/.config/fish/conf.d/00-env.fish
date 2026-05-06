# Core environment shared across machines.
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

set -gx EDITOR nvim
set -gx VISUAL nvim
