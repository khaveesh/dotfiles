# Defined in - @ line 1
function which --description 'Extend `which` to follow symbolic links and return their realpath'
    set path (command -v $argv[1]) &&
        echo "$path" &&
        if test -L "$path"
            realpath "$path"
        end
end
