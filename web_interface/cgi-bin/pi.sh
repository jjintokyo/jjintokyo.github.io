#!/bin/bash

hostname1=$(hostname)
hostname2=$(hostname -I | cut -d' ' -f1)
iostat=$(iostat)
vcgencmd=$(sudo vcgencmd measure_temp)
free=$(free -h)
df=$(df -h)
top=$(top -b -n1 -c -w)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR='Black'>"
echo "<pre>"
echo "<FONT SIZE=3 COLOR='Violet'>"
echo "------------"
echo "| hostname |"
echo "------------"
echo "$hostname1 = $hostname2"
echo "<FONT SIZE=3 COLOR='LimeGreen'>"
echo "----------"
echo "| iostat |"
echo "----------"
echo "$iostat"
echo "<FONT SIZE=3 COLOR='Crimson'>"
echo "-------------------------"
echo "| vcgencmd measure_temp |"
echo "-------------------------"
echo "$vcgencmd"
echo "<FONT SIZE=3 COLOR='DodgerBlue'>"
echo "-----------"
echo "| free -h |"
echo "-----------"
echo "$free"
echo "<FONT SIZE=3 COLOR='Yellow'>"
echo "---------"
echo "| df -h |"
echo "---------"
echo "$df"
echo "<FONT SIZE=3 COLOR='Peru'>"
echo "-------"
echo "| top |"
echo "-------"
echo "$top"
echo "</pre>"
echo "</body>"
echo "</html>"
