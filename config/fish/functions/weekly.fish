# Defined in - @ line 1
function weekly --wraps='fisher self-update; fisher; vim +PackerSync' --description 'alias weekly fisher self-update; fisher; vim +PackerSync'
    fisher self-update
    fisher
    vim +PackerSync
end
