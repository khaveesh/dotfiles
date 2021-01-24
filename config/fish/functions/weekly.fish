# Defined in - @ line 1
function weekly --description 'alias weekly fisher update; nvim +PackagerUpdate; curl https://raw.githubusercontent.com/ookangzheng/dbl-oisd-nl/master/hosts_light.txt > /etc/hosts'
    fisher update
    nvim +PackagerUpdate
    curl https://raw.githubusercontent.com/ookangzheng/dbl-oisd-nl/master/hosts_light.txt >/etc/hosts
end
