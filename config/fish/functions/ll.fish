# Defined in - @ line 1
function ll --wraps='exa -lbGF --git' --description 'alias ll exa -lbGF --git'
    exa -albGF --git --group-directories-first $argv
end
