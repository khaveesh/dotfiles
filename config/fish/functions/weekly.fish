# Defined in - @ line 1
function weekly --wraps='fisher update; vim +PackerSync' --description 'alias weekly fisher update; vim +PackerSync'
    fisher update
    vim +PackerSync
end
