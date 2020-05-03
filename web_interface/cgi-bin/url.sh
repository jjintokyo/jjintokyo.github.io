#!/bin/bash

IFS=$'\n' read -d '' -r -a lines < /home/pi/temp/playlist.db
lines[40]=$(cat /home/pi/temp/special.db)

sudo cat <<EOF | sudo tee /var/www/html/url_body.html > /dev/null
	<html>
	<head>
		<title>Update URLs</title>
	</head>
	<body BGCOLOR="Beige" TEXT="Black">
	<FORM action="cgi-bin/url_save.sh" method="POST" target="url_status">
	<HR>
	<div align="center">
	<table border="0" cellspacing="22" cellpadding="0">
		<tr align="center">
			<td width="22" align="center"><img src="warn.gif" alt="warn"></td>
			<td width="222" align="center">
				<input type="submit" value="Click here to save your change(s)" 
				style="background-color:LightGreen;">
			</td>
			<td width="22" align="center"><img src="warn.gif" alt="warn"></td>
		</tr>
	</table>
	<table border="3" cellspacing="3" cellpadding="3">
EOF

for ((i = 0; i <= 40; i++)); do

nb=$(("$i" + 1))
if [ "$nb" -lt 10 ]; then
  nb="0$nb"
fi
if [ "$nb" -eq 41 ]; then
  nb="SP"
fi

sudo cat <<EOF | sudo tee -a /var/www/html/url_body.html > /dev/null
	<tr align="center">
		<td width="10%" align="center"><b>$nb</b></td>
		<td width="60%" align="left">
			<input type="url" name="$nb" id="$nb" value="${lines[$i]}" 
			pattern="http://.*" size="80" required>
		</td>
		<td width="15%" align="center">
			<button type="submit" formaction="cgi-bin/url_check.sh?$i" 
			formmethod="POST" formtarget="url_status" style=background-color:LightBlue;>Check</button>
		</td>
		<td width="15%" align="center">
			<button type="submit" formaction="cgi-bin/url_play.sh?$i" 
			formmethod="POST" formtarget="url_status" style=background-color:Yellow;>Play</button>
		</td>
	</tr>
EOF
done

sudo cat <<EOF | sudo tee -a /var/www/html/url_body.html > /dev/null
	</table>
	</div>
	</FORM>
	</body>
	</html>
EOF

echo "Content-Type: text/html"
echo ""
echo "<HTML>"
echo "<HEAD>"
echo "		<TITLE>Update URLs</TITLE>"
echo "</HEAD>"
echo "<frameset rows='17%,83%' frameborder='0' framespacing='0' border='0'>"
echo "		<frame src='../url_header.html' name='url_header'>"
echo "		<frameset cols='80%,20%' frameborder='0' framespacing='0' border='0'>"
echo "			<frame src='../url_body.html' name='url_body'>"
echo "			<frame src='../url_status.html' name='url_status'>"
echo "		</frameset>"
echo "</frameset>"
echo "</HTML>"
