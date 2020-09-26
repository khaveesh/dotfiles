# Defined in - @ line 1
function cdf --wraps=cd\ \(osascript\ -e\ \'tell\ app\ \"Finder\"\ to\ POSIX\ path\ of\ \(insertion\ location\ as\ alias\)\'\) --description alias\ cdf\ cd\ \(osascript\ -e\ \'tell\ app\ \"Finder\"\ to\ POSIX\ path\ of\ \(insertion\ location\ as\ alias\)\'\)
    cd (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
