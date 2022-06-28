# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Convert pandoc file formats to HTML using water.css'
    set argv[1] (realpath $argv[1])
    pushd /tmp
    set temp_file (basename $argv[1]).html
    pandoc --toc -L refnos.lua -f markdown+rebase_relative_paths -C --csl=ieee -M link-citations --katex --template markdown -c ~/.local/share/pandoc/style.min.css -c ~/.local/share/pandoc/overrides.css --resource-path=(dirname $argv[1]) -V abstract-title='Abstract:' $argv -o $temp_file && open $temp_file
    popd
end
