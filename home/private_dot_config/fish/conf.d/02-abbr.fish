# Check if bat is available and set abbreviation
if type -q bat
    abbr -a cat bat
end

if type -q eza
    abbr -a ls eza
    abbr -a la 'eza -lah --group-directories-first --icons --git'
    abbr -a las 'eza -lah --group-directories-first --icons --git --total-size'
end

if type -q nvim
    abbr -a vim nvim
end

abbr -a gs 'git status'
abbr -a gd 'git diff'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gb 'git branch'
abbr -a gco 'git checkout'
abbr -a gr 'git rev-parse --show-toplevel'

# Competitive programming abbreviations
# g++-11 compiles pre-compiled stdc++.h the fastest
abbr -a c --set-cursor 'g++-11 -std=c++20 -O2 -Wall -Wextra -Wshadow -DLOCAL -o a %.cpp'
abbr -a a './a'

# ... for ../..
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd
