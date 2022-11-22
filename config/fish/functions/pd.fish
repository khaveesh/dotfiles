# Defined in - @ line 1
function pd --wraps=pandoc --description 'Pandoc powered markdown conversion'
    set author 'Khaveesh N'

    pandoc --defaults=$argv[1] $argv[2] --output=$argv[3] \
        -V title=$argv[4] -V title-meta=$argv[4] \
        -V author=$author -V author-meta=$author \
        $argv[5..]
end
