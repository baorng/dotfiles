# Check if Homebrew is installed and initialize it
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Check if zoxide is installed and initialize it
if type -q zoxide
    zoxide init fish | source
end

# Check if opam is installed and set its environment
if type -q opam
    eval (opam env)
end

