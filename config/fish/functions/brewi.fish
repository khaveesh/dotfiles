# Defined in - @ line 1
function brewi --wraps='brew install --formula' --description 'alias brewi brew install --formula'
    brew install --formula $argv
end
