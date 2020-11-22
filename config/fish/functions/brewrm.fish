# Defined in - @ line 1
function brewrm --wraps='brew uninstall --formula' --description 'alias brewrm brew uninstall --formula'
    brew uninstall --formula $argv
end
