# Check if bat is available and set abbreviation
if type -q bat
    abbr -a cat 'bat'
end

if type -q nvim
    abbr -a vim 'nvim'
end

abbr -a gs 'git status'

# Competitive programming abbreviations
# g++-11 compiles pre-compiled stdc++.h the fastest
abbr -a c 'g++-11 -std=c++20 -O2 -Wall -Wextra -Wshadow -DLOCAL -o a' 
abbr -a a './a'
