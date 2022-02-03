# Defined in - @ line 1
function clang-tidy --description 'C/C++ Linter'
    command clang-tidy -quiet --extra-arg='-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk' $argv 2>/dev/null
end
