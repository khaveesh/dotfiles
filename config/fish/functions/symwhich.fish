# Defined in - @ line 1
function symwhich --description 'Extends which to follow symbolic links and return their path'
    which $argv[1] &&
    if test -L (which $argv[1])
        realpath (which $argv[1])
    end
end
