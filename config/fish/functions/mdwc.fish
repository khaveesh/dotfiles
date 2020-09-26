# Defined in - @ line 1
function mdwc --wraps='pandoc --lua-filter wc.lua' --description 'alias mdwc pandoc --lua-filter wc.lua'
    pandoc --lua-filter wc.lua $argv
end
