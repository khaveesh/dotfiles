# Defined in - @ line 1
function brewi --wraps='brew install' --description 'alias brewi brew install'
    brew install $argv
end
