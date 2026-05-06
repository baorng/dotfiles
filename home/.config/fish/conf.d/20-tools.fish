# Personal interactive tool setup shared across machines.
if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end
