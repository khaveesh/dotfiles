# Defined in - @ line 1
function tar --wraps='tar --disable-copyfile --exclude "*.DS_Store" -cvzf' --description 'alias tar tar --disable-copyfile --exclude "*.DS_Store" -cvzf'
    command tar --disable-copyfile --exclude "*.DS_Store" -cvzf $argv
end
