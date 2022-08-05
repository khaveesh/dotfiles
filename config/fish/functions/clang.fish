# Defined in - @ line 1
function clang --wraps=clang
    command clang -std=c18 -O2 -march=native -flto=thin \
        -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
        -Weverything -Wno-padded \
        $argv
end
