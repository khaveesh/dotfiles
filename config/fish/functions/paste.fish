# Defined in - @ line 1
function paste --wraps='pbpaste >' --description 'alias paste pbpaste >'
    pbpaste >$argv
end
