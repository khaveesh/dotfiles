# Defined in - @ line 1
function panhtml --wraps=pandoc --description 'Typesets any format to LaTeX-style HTML'
    if set -q argv[2]
        set temp_file '/tmp/pandoc.html'
        if test $argv[2] = 'tex' -o $argv[2] = 'latex'
            set argv[2] 'latex'
        else
            set argv[2] 'markdown'
        end
    else
        set temp_file /tmp/(basename $argv[1]).html
    end
    pandoc --lua-filter=absolute.lua $argv[1..-1] -o $temp_file --katex --css=https://cdn.jsdelivr.net/npm/water.css@2/out/light.min.css -H $HOME/.local/share/pandoc/overrides.html && open $temp_file
end
