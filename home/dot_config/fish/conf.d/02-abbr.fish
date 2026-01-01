# Check if bat is available and set abbreviation
if type -q bat
    abbr -a cat bat
end

if type -q eza
    abbr -a ls eza
    abbr -a la 'eza -lah --group-directories-first --icons --git'
    abbr -a las 'eza -lah --group-directories-first --icons --git --total-size'
end

# if type -q nvim
#     abbr -a vim nvim
# end

# Git abbreviations
# Core
abbr -a gs 'git status'
abbr -a gl "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)'"
abbr -a gd 'git diff'

# Stage / unstage
abbr -a ga 'git add'
abbr -a grs 'git restore --staged'

# Commit
abbr -a gc 'git commit'
abbr -a gcm 'git commit -m'
abbr -a gca 'git commit --amend'

# Branch & switch (modern Git)
abbr -a gb 'git branch'
abbr -a gsw 'git switch'
abbr -a gswc 'git switch -c'

# Sync
abbr -a gf 'git fetch'
abbr -a gpl 'git pull'
abbr -a gps 'git push'

# Repo root (kept because it's genuinely useful)
abbr -a gr 'cd (git rev-parse --show-toplevel)'

# Competitive programming abbreviations
# g++-11 compiles pre-compiled stdc++.h the fastest
abbr -a c 'g++-11 -std=c++20 -O2 -Wall -Wextra -Wshadow -DLOCAL -o a'
abbr -a a './a'

# ... for ../..
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd
