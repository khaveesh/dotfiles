# Defined in - @ line 1
function trash --description 'Move files and folders to Trash with option to put them back'
    for item in $argv
        set sourcePath (realpath $item | sed 's/\\\\/\\\\\\\\/g' | sed 's/"/\\\\"/g')
        osascript -e 'tell application "Finder" to delete POSIX file "'$sourcePath'"' >/dev/null
    end
end
