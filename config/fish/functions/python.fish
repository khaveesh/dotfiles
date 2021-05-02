# Defined in - @ line 1
function python --wraps=ipython --description 'alias python ipython --no-confirm-exit'
    if set -q argv[1]
        command python $argv
    else
        ipython --no-confirm-exit
    end
end
