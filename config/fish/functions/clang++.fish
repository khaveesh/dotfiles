# Defined in - @ line 1
function clang++ --wraps clang++ --description 'alias clang++ clang++ -Weverything -Wno-padded -Wno-poison-system-directories -O2 -mmacosx-version-min=11.0 -mavx2 -std=c++17 -march=native -mtune=skylake'
    command clang++ -Weverything -Wno-padded -Wno-poison-system-directories -O2 -mmacosx-version-min=11.0 -mavx2 -std=c++17 -march=native -mtune=skylake $argv
end
