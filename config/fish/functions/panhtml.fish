# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Convert pandoc file formats to HTML'
    set argv[1] (realpath $argv[1])
    set temp_file /tmp/(basename $argv[1]).html

    pandoc --template=modern --embed-resources --toc --mathml -L refnos.lua \
        -c ~/.local/share/pandoc/style.min.css \
        -c ~/.local/share/pandoc/overrides.css \
        -C --csl=ieee -M link-citations \
        -V lang=en-GB -V abstract-title='Abstract:' \
        --resource-path=(dirname $argv[1]) \
        $argv -o $temp_file \
        && open $temp_file
end
