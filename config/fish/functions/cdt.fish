# Defined in - @ line 1
function cdt --description 'Change directory to the given file'
    cd (dirname $argv[1])
end
