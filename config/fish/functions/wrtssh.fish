# Defined in - @ line 1
function wrtssh --description 'SSH into OpenWrt router'
    ssh root@192.168.1.1 -oHostKeyAlgorithms=+ssh-rsa -m hmac-sha2-256
end
