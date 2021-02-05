# Defined in - @ line 1
function diff --wraps='kitty +kitten diff' --description 'alias diff kitty +kitten diff'
    kitty +kitten diff $argv[1] $argv[2]
end
