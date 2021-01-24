# Defined in - @ line 1
function brewl --wraps='brew info' --description 'alias brewl brew info'
    brew info $argv
end
