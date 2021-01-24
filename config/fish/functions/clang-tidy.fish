# Defined in - @ line 1
function clang-tidy --wraps=clang-tidy\ -quiet\ --extra-arg=\'-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX11.0.sdk\' --description alias\ clang-tidy\ clang-tidy\ -quiet\ --extra-arg=\'-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX11.0.sdk\'
    command clang-tidy -quiet --extra-arg='-isysroot/Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk' $argv
end
