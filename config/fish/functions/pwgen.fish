# Defined in - @ line 1
function pwgen --description 'Generates random passwords'
    set -q argv[1] || set argv[1] 15
    LC_ALL=C tr -dc '[:graph:]' </dev/urandom | head -c $argv[1] | pbcopy
    pbpaste
end
