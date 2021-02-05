# Defined in - @ line 1
function weekly --wraps='curl https://raw.githubusercontent.com/ookangzheng/dbl-oisd-nl/master/hosts_light.txt > /etc/hosts; nvim +PackagerUpdate' --description 'alias weekly curl https://raw.githubusercontent.com/ookangzheng/dbl-oisd-nl/master/hosts_light.txt > /etc/hosts; nvim +PackagerUpdate'
    curl https://raw.githubusercontent.com/ookangzheng/dbl-oisd-nl/master/hosts_light.txt >/etc/hosts
    nvim +PackagerUpdate
end
