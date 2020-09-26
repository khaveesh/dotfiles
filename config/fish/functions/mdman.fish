# Defined in - @ line 2
function mdman --wraps='pandoc -s -t man | groff -T utf8 -man | less' --description 'alias mdman pandoc -s -t man | groff -T utf8 -man | less'
    pandoc -s -t man $argv | groff -T utf8 -man | less
end
