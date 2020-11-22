# Defined in - @ line 1
function cdf --description 'Changes PWD to the directory open in foremost Finder window'
    cd (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
