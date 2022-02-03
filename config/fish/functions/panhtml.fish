# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Convert pandoc file formats to HTML using water.css'
    set temp_file /tmp/(basename $argv[1]).html
    pandoc -L refnos.lua -L absolute.lua -C --csl=ieee -M link-citations --katex -c https://cdn.jsdelivr.net/npm/water.css@2/out/light.min.css -H ~/.local/share/pandoc/overrides.html --resource-path=(dirname $argv[1]) $argv -o $temp_file && open $temp_file
end
