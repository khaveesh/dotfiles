# Defined in - @ line 1
function texspell --description 'alias texspell set bold (tput bold) && set normal (tput sgr0) && echo "$bold$argv$normal" && aspell list -t <$argv[1] | sort | uniq && echo'
    set bold (tput bold) && set normal (tput sgr0) && echo "$bold$argv$normal" && aspell list -t <$argv[1] | sort | uniq && echo
end
