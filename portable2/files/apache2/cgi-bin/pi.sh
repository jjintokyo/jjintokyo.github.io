#!/bin/sh

export PATH=$PATH:/mnt/sda1/packages/usr/bin/:/tmp/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/sda1/packages/usr/lib/:/tmp/packages/usr/lib/

machine=$(/bin/cat /proc/cpuinfo | /bin/grep 'machine' | /usr/bin/cut -d: -f2 | /usr/bin/awk '{ print $1, $2 }')
hostname1=$(/bin/cat /etc/config/system | /bin/grep 'hostname' | /usr/bin/cut -d"'" -f2)
hostname2=$(/sbin/ifconfig wlan0 | /bin/grep 'inet addr:' | /usr/bin/cut -d: -f2 | /usr/bin/awk '{ print $1 }')
uptime=$(/usr/bin/uptime); uptime=$(/bin/echo $uptime)
mpc1=$(/usr/bin/mpc current)
mpc2=$(/usr/bin/mpc current -f %file%)
netstat=$(/bin/netstat -tpW)
iwinfo=$(/usr/sbin/iw dev wlan0 link)
ifconfig=$(/sbin/ifconfig wlan0)
wireless=$(/bin/cat /proc/net/wireless)
statistics=$(/bin/cat /proc/net/dev)
iostat=$(/usr/bin/iostat ALL --human)
free=$(/usr/bin/free -h)
df=$(/bin/df -h)
top=$(/usr/bin/top -b -n1)

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor='Black'>"
echo "<font size=3>"
echo "<pre>"
echo "<font color='Violet'>"
echo "-----------"
echo "| machine |"
echo "-----------"
echo "$machine"
echo "<font color='Coral'>"
echo "------------"
echo "| hostname |"
echo "------------"
echo "$hostname1 = $hostname2"
echo "<font color='Crimson'>"
echo "----------"
echo "| uptime |"
echo "----------"
echo "$uptime"
echo "<font color='BurlyWood'>"
echo "--------------------"
echo "| radio playing... |"
echo "--------------------"
if [ "$mpc1" == "" ] && [ "$mpc2" == "" ]; then
    echo "Nothing!"
else
    if [ "$mpc1" == "$mpc2" ]; then
        echo "$mpc1"
    else
        echo "$mpc1"; echo "$mpc2"
    fi
fi
echo "<font color='Olive'>"
echo "-----------"
echo "| netstat |"
echo "-----------"
echo "$netstat"
echo "<font color='LimeGreen'>"
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
echo "<font color='DodgerBlue'>"
echo "----------"
echo "| iostat |"
echo "----------"
echo "$iostat"
echo "<font color='Aqua'>"
echo "-----------"
echo "| free -h |"
echo "-----------"
echo "$free"
echo "<font color='Yellow'>"
echo "---------"
echo "| df -h |"
echo "---------"
echo "$df"
echo "<font color='Peru'>"
echo "-------"
echo "| top |"
echo "-------"
echo "$top"
echo "</pre>"
echo "</body>"
echo "</html>"
