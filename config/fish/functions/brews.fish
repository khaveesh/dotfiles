# Defined in - @ line 1
function brews --wraps='brew search' --description 'alias brews brew search'
    brew search $argv[1]
end
