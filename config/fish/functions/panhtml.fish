# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Pandoc markdown previewer'
    set temp_file (basename $argv[1] .md).xhtml

    pandoc --defaults=html $argv --output=$temp_file \
        --resource-path=(dirname $argv[1]) \
        && open $temp_file
end
