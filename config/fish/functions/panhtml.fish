function panhtml --wraps=pandoc --description 'Typesets any format to LaTeX-style HTML'
    set temp_file (echo $argv[1] | sed 's/.*\/\(.*\)$/\1/')
    set temp_file /tmp/$temp_file.html
    pandoc --lua-filter=absolute.lua $argv[1] -o $temp_file --katex --css=https://cdn.jsdelivr.net/npm/water.css@2/out/light.min.css -H $HOME/.local/share/pandoc/overrides.html && open $temp_file
end
