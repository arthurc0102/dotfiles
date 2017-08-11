read -p "IP address of the computer you want to remote : " ip
read -p "Port of the computer you wnat to remoter      : " port
read -p "The file localtion you want to mount          : " location
rdesktop -g 1920x1015 -P -z -x l -r sound:off -r disk:share=${location} ${ip}:${port} &> /dev/null &
