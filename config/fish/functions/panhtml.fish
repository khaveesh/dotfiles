# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Convert pandoc file formats to HTML'
    set argv[1] (realpath $argv[1])
    set temp_file /tmp/(basename $argv[1]).xhtml

    pandoc --defaults=html $argv --output=$temp_file \
        --resource-path=(dirname $argv[1]) \
        && open $temp_file
end
