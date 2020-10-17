# Defined in - @ line 1
function clang --wraps='clang -Weverything -Wno-padded -O2 -mmacosx-version-min=10.15 -mavx2 -std=c17 -march=native -mtune=skylake' --description 'alias clang clang -Weverything -Wno-padded -O2 -mmacosx-version-min=10.15 -mavx2 -std=c17 -march=native -mtune=skylake'
    command clang -Weverything -Wno-padded -O2 -mmacosx-version-min=10.15 -mavx2 -std=c17 -march=native -mtune=skylake $argv
end
