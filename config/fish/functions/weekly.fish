# Defined in - @ line 1
function weekly --wraps='fisher update; vim +PackagerUpdate' --description 'alias weekly fisher update; vim +PackagerUpdate'
    fisher update
    vim +PackagerUpdate $argv
end
