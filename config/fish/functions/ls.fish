# Defined in - @ line 1
function ls --wraps='exa -xF --group-directories-first --git-ignore' --description 'alias ls exa -xF --group-directories-first --git-ignore'
    exa -xF --group-directories-first --git-ignore $argv
end
