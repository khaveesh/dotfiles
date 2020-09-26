# Defined in - @ line 1
function brewls --wraps='brew info' --description 'alias brewls brew info'
    brew info $argv
end
