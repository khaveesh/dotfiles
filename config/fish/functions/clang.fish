# Defined in - @ line 1
function clang --wraps=clang
    command clang -Weverything -Wno-padded -Wno-poison-system-directories -O2 -mmacosx-version-min=12.0 -mavx2 -std=c18 -march=native -mtune=skylake $argv
end
