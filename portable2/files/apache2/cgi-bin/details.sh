#!/bin/sh

export PATH=$PATH:/mnt/sda1/packages/usr/bin/:/tmp/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/sda1/packages/usr/lib/:/tmp/packages/usr/lib/

url1=$(/bin/cat /tmp/url1.txt)
details=$(/root/my_radio/get_the_stream_title.py $url1)
url2=$(/bin/cat /tmp/url2.txt)

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<font size=4 color=Blue>"
echo "<b>$url1</b><br><br>"
echo "<font color=Black>"
echo "<b>$url2</b><br>"
echo "<pre>$details</pre>"
echo "</body>"
echo "</html>"
