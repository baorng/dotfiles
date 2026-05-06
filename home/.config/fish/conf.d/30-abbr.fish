# Abbreviations expand on space, keeping commands readable in history.
if type -q bat
    abbr -a cat bat
end

if type -q eza
    abbr -a ls eza
    abbr -a la 'eza -lah --group-directories-first --icons --git'
    abbr -a las 'eza -lah --group-directories-first --icons --git --total-size'
end

abbr -a gs 'git status'
abbr -a gl "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)'"
abbr -a gd 'git diff'
abbr -a ga 'git add'
abbr -a grs 'git restore --staged'
abbr -a gc 'git commit'
abbr -a gcm 'git commit -m'
abbr -a gca 'git commit --amend'
abbr -a gb 'git branch'
abbr -a gsw 'git switch'
abbr -a gswc 'git switch -c'
abbr -a gf 'git fetch'
abbr -a gpl 'git pull'
abbr -a gps 'git push'
abbr -a gr 'cd (git rev-parse --show-toplevel)'

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd
