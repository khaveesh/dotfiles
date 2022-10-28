# Defined in - @ line 1
function clang-tidy --wraps=clang-tidy --description 'C/C++ Linter'
    command clang-tidy -quiet \
        $argv -- \
        -resource-dir /Library/Developer/CommandLineTools/usr/lib/clang/* \
        -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
        -I /usr/local/include 2>/dev/null
end
