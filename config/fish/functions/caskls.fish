# Defined in - @ line 1
function caskls --wraps='brew info --cask' --description 'alias caskls brew info --cask'
    brew info --cask $argv
end
