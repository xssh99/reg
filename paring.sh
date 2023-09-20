#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
###########- COLOR CODE -##############

clear
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
  clear
  echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\e[42m             SSH Ovpn Account            \E[0m"
  echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  read -p "Username : " user

  CLIENT_EXISTS=$(grep -w $user /etc/ssh/.ssh.db | wc -l)

  if [[ ${CLIENT_EXISTS} == '1' ]]; then
    clear
    echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\e[42m             SSH Ovpn Account            \E[0m"
    echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo "A client with the specified name was already created, please choose another name."
    echo ""
    echo -e "\033[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    read -n 1 -s -r -p "Press any key to back on menu"
    menu
  fi
done
sec=3
spinner=(⣻ ⢿ ⡿ ⣟ ⣯ ⣷)
while [ $sec -gt 0 ]; do
    echo -ne "\e[33m ${spinner[sec]} Setting up a Premium Account $sec seconds...\r"
    sleep 1
    sec=$(($sec - 1))
done
clear 
echo -e "\e[1;32mINPUT DEPENDECIES ACCOUNT $user\e[0m\n"
until [[ $PASSWD =~ ^[a-zA-Z0-9]+$ ]]; do
read -p "Password : " PASSWD
done
until [[ $EXPIRED =~ ^[0-9]+$ ]]; do
read -p "Expired (days): " EXPIRED
done
until [[ $iplim =~ ^[0-9]+$ ]]; do
read -p "Limit User (IP): " iplim
done
IP=$(curl -sS ifconfig.me)
CITY=$(cat /etc/xray/city)
PUB=$(cat /etc/slowdns/server.pub)
NS=$(cat /etc/xray/dns)
domain=$(cat /etc/xray/domain)
useradd -e $(date -d "$EXPIRED days" +"%Y-%m-%d") -s /bin/false -M $user
exp="$(chage -l $user | grep "Account expires" | awk -F": " '{print $2}')"
dbexp=$(date -d "$EXPIRED days" +"%Y-%m-%d")
echo -e "$PASSWD\n$PASSWD\n" | passwd $user &>/dev/null

if [[ ${c} != "0" ]]; then
  echo "${iplim}" >/etc/ssh/${user}
fi
DATADB=$(cat /etc/ssh/.ssh.db | grep "^###" | grep -w "${user}" | awk '{print $2}')
if [[ "${DATADB}" != '' ]]; then
  sed -i "/\b${user}\b/d" /etc/ssh/.ssh.db
fi
echo "### ${user} ${dbexp}" >>/etc/ssh/.ssh.db

cat >/var/www/html/ssh-$user.txt <<END

---------------------
Format SSH OVPN Account
---------------------

Username         : $user
Password         : $PASSWD
Expired          : $exp
---------------------
IP               : $IP
Host             : $domain
Host Slowdns     : ${NS}
Pub Key          : ${PUB}
Port OpenSSH     : 22
Port UdpSSH      : 1-65535
Port Dropbear    : 143, 109
Port Dropbear WS : 80,143
Port SSH WS      : 80
Port SSH SSL WS  : 443
Port SSL/TLS     : 447,8443
Port OVPN WS SSL : 443
Port OVPN SSL    : 990
Port OVPN TCP    : 443, 1194
Port OVPN UDP    : 2200
BadVPN UDP       : 7100, 7300, 7300
---------------------
Payload WSS: GET ws://$domain/ HTTP/1.1[crlf]Host: isi_bug_disini[crlf]Upgrade: websocket[crlf][crlf] 
---------------------
OpenVPN SSL : http://$domain:81/ssl.ovpn
OpenVPN TCP : http://$domain:81/tcp.ovpn
OpenVPN UDP : http://$domain:81/udp.ovpn
---------------------

END

clear
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\e[42m      SSH OVPN Account     \E[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Username         : $user" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Password         : $PASSWD" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "IP               : $IP" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Host             : $domain" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "User IP          : ${iplim} IP" | tee -a /etc/xray/log-create-${user}.log
echo -e "Host Slowdns     : ${NS}" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Pub Key          : ${PUB}" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port OpenSSH     : 22" | tee -a /etc/xray/log-createssh-${user}.log 
echo -e "Port UdpSSH      : 1-65535" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port DNS         : 443, 53 ,22 " | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port Dropbear    : 143, 109" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port Dropbear WS : 80, 143" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port SSH WS      : 80" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port SSH SSL WS  : 443" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port SSL/TLS     : 447,8443" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port OVPN WS SSL : 443" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port OVPN SSL    : 443" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port OVPN TCP    : 1194" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Port OVPN UDP    : 2200" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Proxy Squid      : 3128" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "BadVPN UDP       : 7100, 7300, 7300" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Payload WSS      : GET ws://$domain/ HTTP/1.1[crlf]Host: isi_bug_disini[crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "OpenVPN SSL      : https://$domain:81/ssl.ovpn" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "OpenVPN TCP      : https://$domain:81/tcp.ovpn" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "OpenVPN UDP      : https://$domain:81/udp.ovpn" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Save Link Account: https://$domain:81/ssh-$user.txt"
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Expired          : $exp" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "" | tee -a /etc/xray/log-createssh-${user}.log
