#!/bin/sh

machine=$(cat /proc/cpuinfo | grep 'machine' | cut -d: -f2 | awk '{ print $1, $2 }')
hostname1=$(sudo cat /etc/config/system | grep 'hostname' | cut -d"'" -f2)
hostname2=$(/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')
uptime=$(uptime); uptime=$(echo $uptime)
iwinfo=$(iwinfo)
ifconfig=$(/sbin/ifconfig wlan0)
wireless=$(cat /proc/net/wireless)
statistics=$(cat /proc/net/dev)
iostat=$(iostat)
free=$(free -h)
df=$(df -h)
top=$(top -b -n1)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR='Black'>"
echo "<FONT SIZE=3>"
echo "<pre>"
echo "<FONT COLOR='Violet'>"
echo "-----------"
echo "| machine |"
echo "-----------"
echo "$machine"
echo "<FONT COLOR='Coral'>"
echo "------------"
echo "| hostname |"
echo "------------"
echo "$hostname1 = $hostname2"
echo "<FONT COLOR='Crimson'>"
echo "----------"
echo "| uptime |"
echo "----------"
echo "$uptime"
echo "<FONT COLOR='LimeGreen'>"
echo "-----------------"
echo "| wireless info |"
echo "-----------------"
echo "$iwinfo"
echo ""
echo "$ifconfig"
echo ""
echo "$wireless"
echo ""
echo "$statistics"
echo "<FONT COLOR='DodgerBlue'>"
echo "----------"
echo "| iostat |"
echo "----------"
echo "$iostat"
echo "<FONT COLOR='Aqua'>"
echo "-----------"
echo "| free -h |"
echo "-----------"
echo "$free"
echo "<FONT COLOR='Yellow'>"
echo "---------"
echo "| df -h |"
echo "---------"
echo "$df"
echo "<FONT COLOR='Peru'>"
echo "-------"
echo "| top |"
echo "-------"
echo "$top"
echo "</pre>"
echo "</body>"
echo "</html>"
