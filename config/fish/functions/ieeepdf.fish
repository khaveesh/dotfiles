# Defined in - @ line 2
function ieeepdf --wraps=pandoc --description 'Converts pandoc file formats to IEEE-style PDF'
    set author 'Khaveesh N'
    pandoc --pdf-engine=lualatex --template=ieee -N -C --csl=ieee -M link-citations $argv[1] -o $argv[2] -V documentclass=IEEEtran -V lang=en-GB -V mainfont='Times' -V mainfontoptions='SmallCapsFont=Latin Modern Roman Caps' -V monofont='SF Mono' -V indent -V csquotes -V urlcolor=[HTML]{0063D7} -V title="$argv[3]" -V title-meta="$argv[3]" -V author=$author -V author-meta=$author -H ~/.local/share/pandoc/table-xtab.tex $argv[4..]
end
