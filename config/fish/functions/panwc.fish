# Defined in - @ line 1
function panwc --wraps='pandoc --lua-filter wc.lua' --description 'alias panwc pandoc --lua-filter wc.lua'
    pandoc --lua-filter wc.lua $argv
end
