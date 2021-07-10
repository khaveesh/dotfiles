# Defined in - @ line 1
function ctar --wraps='tar --exclude "*.DS_Store" -cvzf' --description 'alias ctar tar --exclude "*.DS_Store" -cvzf'
    tar --exclude "*.DS_Store" -cvzf $argv
end
