# Defined in - @ line 1
function ctar --wraps='tar --no-mac-metadata -cvzf' --description 'alias ctar tar --no-mac-metadata -cvzf'
    command tar --no-mac-metadata -cvzf $argv
end
