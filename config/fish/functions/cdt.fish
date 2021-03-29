# Defined in - @ line 1
function cdt --description 'Change PWD to the directory containing the given file'
    cd (dirname $argv[1])
end
