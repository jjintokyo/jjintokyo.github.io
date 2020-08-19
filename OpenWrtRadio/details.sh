#!/bin/sh

export PATH=$PATH:/tmp/ubi1/packages/usr/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/ubi1/packages/usr/lib/

url1=$(cat /tmp/ubi1/random/url1.txt)
details=$(/tmp/ubi1/random/get_the_stream_title.py $url1)
url2=$(cat /tmp/ubi1/random/url2.txt)

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<FONT SIZE=4 COLOR=Blue>"
echo "<B>$url1</B><BR><BR>"
echo "<FONT COLOR=Black>"
echo "<B>$url2</B><BR>"
echo "<pre>$details</pre>"
echo "</body>"
echo "</html>"
