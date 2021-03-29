# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Converts any format to HTML using water.css'
    set temp_file /tmp/(basename $argv[1]).html
    pandoc -C --csl=ieee -M link-citations -L absolute.lua --katex -c https://cdn.jsdelivr.net/npm/water.css@2/out/light.min.css -H ~/.local/share/pandoc/overrides.html $argv[..] -o $temp_file && open $temp_file
end
