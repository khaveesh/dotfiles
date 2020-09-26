# Defined in - @ line 1
function ls --wraps=exa --description 'alias ls exa'
    exa -aF --group-directories-first $argv
end
