# Defined in - @ line 1
function rg --wraps=rg --description 'alias rg kitty +kitten hyperlinked_grep --engine auto'
    kitty +kitten hyperlinked_grep --engine auto $argv
end
