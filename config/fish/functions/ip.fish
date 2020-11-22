# Defined in - @ line 1
function ip --description 'Lists IP addresses'
    echo -n 'IPv4: '
    dig +short myip.opendns.com @resolver1.opendns.com -4
    echo -n 'IPv6: '
    dig +short myip.opendns.com AAAA @resolver1.opendns.com
end
