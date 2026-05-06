# Personal paths shared across machines.
fish_add_path -g $HOME/.local/bin

# Homebrew is foundational on macOS, so keep it in tracked core config.
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end
