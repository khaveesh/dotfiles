# Defined in - @ line 1
function fd --wraps=fd --description 'alias fd fd -E /System'
    command fd -E /System $argv
end
