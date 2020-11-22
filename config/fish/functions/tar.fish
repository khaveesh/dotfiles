# Defined in - @ line 1
function tar --wraps='tar --no-mac-metadata -cvzf' --description 'alias tar tar --no-mac-metadata -cvzf'
    command tar --no-mac-metadata -cvzf $argv
end
