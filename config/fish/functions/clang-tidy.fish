# Defined in - @ line 1
function clang-tidy --description 'C/C++ Linter'
    command clang-tidy -quiet \
        $argv -- \
        -resource-dir /Library/Developer/CommandLineTools/usr/lib/clang/13.1.6 \
        -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
        -I /usr/local/include 2>/dev/null
end
