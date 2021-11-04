function azip --wraps='bsdtar --exclude "*.DS_Store" --no-mac-metadata -a -cvf' --description 'Multi-format compressor'
    bsdtar --exclude "*.DS_Store" --no-mac-metadata -a -cvf $argv
end
