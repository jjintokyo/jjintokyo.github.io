#!/bin/sh

export PATH=$PATH:/mnt/sda1/packages/usr/bin/:/tmp/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/sda1/packages/usr/lib/:/tmp/packages/usr/lib/

eval $(/bin/echo ${QUERY_STRING//&/;})
if [ "$mySelection" == "Everything" ]; then
    cmd1=$(/root/my_radio/random_run.py)
else
    cmd1=$(/root/my_radio/random_run.py "$mySelection")
fi

if [ "$cmd1" == "Nothing Found!" ] || [ "$cmd1" == "" ]; then
    url="Nothing Found!"; genre="/"; cmd2=""; nb_records=0
else
    nb_records=$(/bin/echo $cmd1 | /usr/bin/cut -f1 -d' ')
    url=$(/bin/echo $cmd1 | /usr/bin/cut -f2 -d' ')
    genre=$(/bin/echo $cmd1 | /usr/bin/cut -f3- -d' ')
    /bin/echo $url | /usr/bin/tee /tmp/url1.txt > /dev/null
    /usr/bin/mpc del 41 &>/dev/null
    /usr/bin/mpc add "$url" &>/dev/null
    /usr/bin/mpc play 41 &>/dev/null
    /bin/sleep 1
    cmd2=$(/usr/bin/mpc status)
fi

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<table border='0' cellpadding='0' cellspacing='0'>"
echo "<tr>"
echo "<td align='left'>"
echo "<font size=4 color=Black>"
echo "Random Web Radio..... <b>$mySelection</b> &nbsp;&nbsp;&nbsp;($nb_records records found)"
echo "</td>"
echo "<td width='3%' rowspan='2'></td>"
echo "<td rowspan='2' align='right'>"
echo "<img src='/dancingalien.gif' alt='dancing alien' border=0>"
echo "</td>"
echo "</tr>"
echo "<tr>"
echo "<td align='left'>"
echo "<font size=4 color=Blue>"
echo "<b>URL = $url<br>GENRE = $genre</b>"
echo "</td>"
echo "</tr>"
echo "<tr>"
echo "<td align='left'>"
echo "<font size=4 color=Black>"
echo "<h3><pre>$cmd2</pre></h3>"
echo "</td>"
echo "</tr>"
echo "</table>"
echo "</body>"
echo "</html>"
