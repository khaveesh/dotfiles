# Defined in - @ line 1
function brewls --wraps='brew info --formula' --description 'alias brewls brew info --formula'
    brew info --formula $argv
end
