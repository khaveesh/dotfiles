# Defined in - @ line 1
function mkpdf --wraps='latexmk -lualatex -quiet && latexmk -c' --description 'alias mkpdf latexmk -lualatex -quiet && latexmk -c'
    latexmk -lualatex -quiet $argv &>/dev/null && latexmk -c &>/dev/null
end
