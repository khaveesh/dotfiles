function azip --wraps='tar --exclude "*.DS_Store" --no-mac-metadata -a -cvf' --description 'Multi-format compressor'
    tar --exclude "*.DS_Store" --no-mac-metadata -a -cvf $argv
end
