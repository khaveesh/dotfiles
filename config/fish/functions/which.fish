# Defined in - @ line 1
function which --description 'Extends which to follow symbolic links and return their path'
    set path (command which $argv[1]) &&
        echo "$path" &&
        if test -L "$path"
            realpath "$path"
        end
end
