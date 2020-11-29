# Defined in - @ line 1
function caskrm --wraps='brew uninstall --cask' --description 'alias caskrm brew uninstall --cask'
    brew uninstall --cask $argv
end
