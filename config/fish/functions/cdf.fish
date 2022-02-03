# Defined in - @ line 1
function cdf --description 'Change PWD to the directory open in the frontmost Finder window'
    cd (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
