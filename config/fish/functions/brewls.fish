# Defined in - @ line 1
function brewls --description 'Lists all installed formulae and casks'
    set normal (tput sgr0) && set blue (tput setaf 4) && set bold (tput bold)
    echo "$blue==>$normal$bold Formulae$normal"
    brew list --formula
    echo
    echo "$blue==>$normal$bold Casks$normal"
    brew list --cask
end
