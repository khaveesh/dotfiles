# Defined in - @ line 1
function caskl --wraps='brewl --cask' --wraps='brew list --cask' --description 'alias caskl brew list --cask'
    brew list --cask
end
