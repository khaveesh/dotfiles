# Defined in - @ line 1
function which --description 'Extends which to follow symbolic links and return their path'
    command which $argv[1] &&
        if test -L (command which $argv[1])
            realpath (command which $argv[1])
        end
end
