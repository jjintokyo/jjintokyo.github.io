#!/bin/sh

export PATH=$PATH:/tmp/ubi1/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/ubi1/packages/usr/lib/

eval $(echo ${QUERY_STRING//&/;})
if [ "$mySelection" == "Everything" ]; then
    cmd1=$(/tmp/ubi1/random/random_run.py)
else
    cmd1=$(/tmp/ubi1/random/random_run.py "$mySelection")
fi

if [ "$cmd1" != "Nothing Found!" ]; then
    url=$(echo $cmd1 | cut -f1 -d' ')
    genre=$(echo $cmd1 | cut -f2- -d' ')
    echo $url | sudo tee /tmp/ubi1/random/url1.txt > /dev/null
    /usr/bin/mpc del 41 &>/dev/null
    /usr/bin/mpc add "$url" &>/dev/null
    /usr/bin/mpc play 41 &>/dev/null
    sleep 1
    cmd2=$(/usr/bin/mpc status)
else
    url="$cmd1"; genre="/"; cmd2="";
fi

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<table border='0' cellpadding='0' cellspacing='0'>"
echo "<tr>"
echo "<td align='left'>"
echo "<FONT SIZE=4 COLOR=Black>"
echo "Random Web Radio..... <B>$mySelection</B>"
echo "</td>"
echo "<td width='3%' rowspan='2'></td>"
echo "<td rowspan='2' align='right'>"
echo "<img src='/dancingalien.gif' alt='dancing alien' BORDER=0>"
echo "</td>"
echo "</tr>"
echo "<tr>"
echo "<td align='left'>"
echo "<FONT SIZE=4 COLOR=Blue>"
echo "<B>URL = $url<BR>GENRE = $genre</B>"
echo "</td>"
echo "</tr>"
echo "<tr>"
echo "<td align='left'>"
echo "<FONT SIZE=4 COLOR=Black>"
echo "<h3><pre>$cmd2</pre></h3>"
echo "</td>"
echo "</tr>"
echo "</table>"
echo "</body>"
echo "</html>"
