# Defined in - @ line 1
function azip --wraps=bsdtar --description 'Multi-format compressor'
    bsdtar --create --auto-compress --verbose --file $argv \
        --exclude '*.DS_Store' --no-mac-metadata
end
