# Defined in - @ line 1
function clang-tidy --wraps=clang-tidy\ -quiet\ --extra-arg=\'-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk\'
    command clang-tidy -quiet --extra-arg='-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk' $argv 2>/dev/null
end
