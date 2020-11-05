# Defined in - @ line 1
function weekly --wraps='scuba update; vim +PackerSync' --description 'alias weekly scuba update; vim +PackerSync'
    scuba update
    vim +PackerSync
end
