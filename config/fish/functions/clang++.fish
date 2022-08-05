# Defined in - @ line 1
function clang++ --wraps=clang++
    command clang++ -std=c++17 -O2 -march=native -flto=thin \
        -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
        -Weverything -Wno-padded -Wno-c++98-compat -Wno-c++98-compat-pedantic \
        $argv
end
