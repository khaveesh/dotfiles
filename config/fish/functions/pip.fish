# Defined in - @ line 1
function pip --wraps=pip3 --wraps='python -m pip' --description 'alias pip python -m pip'
    python -m pip $argv
end
