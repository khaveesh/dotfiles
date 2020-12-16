# Defined in - @ line 1
function gtar --wraps='gtar --no-mac-metadata -cvzf' --description 'alias gtar tar --no-mac-metadata -cvzf'
    command tar --no-mac-metadata -cvzf $argv
end
