# Defined in - @ line 1
function cask --wraps='brew cask' --description 'alias cask brew cask'
    brew cask $argv
end
