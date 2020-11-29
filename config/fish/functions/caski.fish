# Defined in - @ line 1
function caski --wraps='brew install --cask' --description 'alias caski brew install --cask'
    brew install --cask $argv
end
