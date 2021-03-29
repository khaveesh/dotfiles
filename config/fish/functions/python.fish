# Defined in - @ line 1
function python --wraps=ipython --description 'alias python ipython --no-confirm-exit'
    ipython --no-confirm-exit $argv
end
