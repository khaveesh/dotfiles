function azip --wraps=bsdtar --description 'Multi-format compressor'
    bsdtar --exclude '*.DS_Store' --no-mac-metadata -a -cvf $argv
end
