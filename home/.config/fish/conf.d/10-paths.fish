# Personal paths shared across machines.
fish_add_path -g $HOME/.local/bin

# Homebrew is foundational on macOS and our Linux toolbelt, so keep it core.
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
