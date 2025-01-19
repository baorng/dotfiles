# Ensure your critical variables exist
set -qg XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -qg XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -qg XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache
# Fix for wsl wl-clip missing runtime
if test -d /mnt/wslg/runtime-dir
    set -gx XDG_RUNTIME_DIR /mnt/wslg/runtime-dir
end

# Favor globals for most things
# set -gx EDITOR nvim
# set -gx VISUAL code
# set -gx VISUAL nvim
set -gx EDITOR hx
set -gx VISUAL hx

# Paths
fish_add_path -g ~/.local/bin

# FIXME: Temporary fix for code in fish-shell/fish-beta-4 WSL
set code_path (which code)
if test -x $code_path
    fish_add_path -g (dirname "$code_path")
end

# FIXME: remove once https://github.com/helix-editor/helix/issues/10089 is fixed
# resets terminal cursor shape on exit
function hx
    command hx $argv
    printf '\033[0 q'
end
