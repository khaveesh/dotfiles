# Defined in - @ line 1
function unalias --wraps='functions -e' --description 'alias unalias functions -e'
    functions -e $argv
end
