# Defined in - @ line 1
function wrtssh --wraps='ssh root@openwrt.lan -oHostKeyAlgorithms=+ssh-rsa -m hmac-sha2-256' --description 'alias wrtssh ssh root@openwrt.lan -oHostKeyAlgorithms=+ssh-rsa -m hmac-sha2-256'
    ssh root@openwrt.lan -oHostKeyAlgorithms=+ssh-rsa -m hmac-sha2-256
end
