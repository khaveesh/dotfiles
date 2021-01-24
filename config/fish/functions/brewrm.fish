# Defined in - @ line 1
function brewrm --wraps='brew uninstall' --description 'alias brewrm brew uninstall'
    brew uninstall $argv && brew autoremove
end
