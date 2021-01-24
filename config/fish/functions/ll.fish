# Defined in - @ line 1
function ll --wraps='exa -alF --git --group-directories-first' --description 'alias ll exa -alF --git --group-directories-first'
    exa -alF --git --group-directories-first $argv
end
