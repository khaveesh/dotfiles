# Defined in - @ line 1
function reload --wraps='exec $SHELL -l' --description 'alias reload exec $SHELL -l'
    exec $SHELL -l
end
