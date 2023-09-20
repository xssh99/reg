#!/bin/bash

# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'
export ungu='\033[0;35m'

# Getting

domain=$(cat /etc/xray/domain)
sldomain=$(cat /etc/xray/dns)
cdndomain=$(cat /root/awscdndomain)
slkey=$(cat /etc/slowdns/server.pub)
clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[44;1;39m                 ⇱ CREATE ACCOUNT ⇲            \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "${CYAN}"
read -p "Username : " user
read -p "Password : " Pass
read -p "Expired (Days): " masaaktif
read -p "limit IP: " max
echo > /etc/cron.d/kills
                echo "# $user" >>/etc/cron.d/kills
                echo "*/5 * * * *  root /usr/bin/kills $max" >> /etc/cron.d/kills
                

IP=$(wget -qO- ipinfo.io/ip);
ws="$(cat ~/log-install.txt | grep -w "Websocket TLS" | cut -d: -f2|sed 's/ //g')"
ws2="$(cat ~/log-install.txt | grep -w "Websocket None TLS" | cut -d: -f2|sed 's/ //g')"

ssl="$(cat ~/log-install.txt | grep -w "Stunnel5" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
clear
systemctl stop client-sldns
systemctl stop server-sldns
pkill sldns-server
pkill sldns-client
systemctl enable client-sldns
systemctl enable server-sldns
systemctl start client-sldns
systemctl start server-sldns
systemctl restart client-sldns
systemctl restart server-sldns

systemctl restart ssh-ohp
systemctl restart rc-local
systemctl restart dropbear-ohp
systemctl restart openvpn-ohp
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $user
expi="$(chage -l $user | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $user &> /dev/null
hariini=`date -d "0 days" +"%Y-%m-%d"`
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
clear
echo -e ""
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\e[42m      SSH OVPN Account     \E[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Username         : $user" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Password         : $Pass" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "\033[1;93m───────────────────────────\033[0m" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "IP               : $IP" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "Host             : $domain" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "User IP          : ${max} IP" | tee -a /etc/xray/log-create-${user}.log
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
echo -e "Expired          : $expi" | tee -a /etc/xray/log-createssh-${user}.log
echo -e "" | tee -a /etc/xray/log-createssh-${user}.log
