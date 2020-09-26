# Defined in - @ line 1
function weekly --wraps='fisher self-update; fisher; vim +PackClean +PackUpdate' --wraps='fisher self-update; fisher; vim +PackSync' --description 'alias weekly fisher self-update; fisher; vim +PackSync'
    fisher self-update
    fisher
    vim +PackSync
end
