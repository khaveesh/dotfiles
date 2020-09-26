# Defined in - @ line 1
function path --wraps=printf\ \"\%s\\n\"\ \$PATH --description alias\ path\ printf\ \"\%s\\n\"\ \$PATH
    printf "%s\n" $PATH
end
