#!/usr/bin/python3
# -*- coding: utf-8 -*-
# echo "%www-data ALL=NOPASSWD: /root/cpu+temp.sh" | sudo tee -a /etc/sudoers

import subprocess

def get_data(command):
    try:
        data = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    except Exception as e:
        data = e.output
    return str(data.decode('utf8').strip())

def process_exists(process_name):
    try:
        returned_output = str(subprocess.check_output("/usr/bin/ps -A", shell=True, stderr=subprocess.STDOUT))
        if process_name in returned_output:
            return True
        else:
            return False
    except Exception as e:
        return False

full_date_time = get_data("/usr/bin/date +'%A %d %B %Y - %T'")
cpu_and_temp   = get_data("/usr/bin/sudo /root/cpu+temp.sh")
machine        = get_data("/usr/bin/cat /sys/firmware/devicetree/base/model")
hostname1      = get_data("/usr/bin/hostname")
hostname2      = get_data("/usr/bin/hostname -I | /usr/bin/cut -d ' ' -f1")
uptime         = get_data("/usr/bin/uptime")
mpc1           = get_data("/usr/bin/mpc current")
mpc2           = get_data("/usr/bin/mpc current -f %file%")
netstat        = get_data("/usr/bin/netstat -tW")
iwinfo         = get_data("/usr/sbin/iw dev wlan0 link")
ifconfig       = get_data("/usr/sbin/ifconfig wlan0")
wireless       = get_data("/usr/bin/cat /proc/net/wireless")
statistics     = get_data("/usr/bin/cat /proc/net/dev")
iostat         = get_data("/usr/bin/iostat ALL --human")
free           = get_data("/usr/bin/free -h")
df             = get_data("/usr/bin/df -h")
top            = get_data("/usr/bin/top -w 512 -cbn 1")

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body bgcolor='Black' text='White'>")
print("<font color='Navy'>")
print("<h1>" + full_date_time + "</h1>")
print("")
print("<font color='Lime'>")
cpu_percent     = cpu_and_temp[cpu_and_temp.index("c") + 1: cpu_and_temp.index("%")].strip()
in_temperature  = cpu_and_temp[cpu_and_temp.index("i") + 1: cpu_and_temp.index("x")].strip()
out_temperature = cpu_and_temp[cpu_and_temp.index("o") + 1: cpu_and_temp.index("y")].strip()
print("<h1>" + "CPU: "      + cpu_percent     + "&percnt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +\
               "IN TEMP: "  + in_temperature  + "&#8451;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"  +\
               "OUT TEMP: " + out_temperature + "&#8451;" + "</h1>")
print("")
print("<font size=4>")
print("<pre>")
print("<font color='Crimson'>")
print("-----------")
print("| machine |")
print("-----------")
print(machine)
print("<font color='Coral'>")
print("------------")
print("| hostname |")
print("------------")
print(hostname1 + " = " + hostname2)
print("<font color='Orchid'>")
print("----------")
print("| uptime |")
print("----------")
print(uptime)
print("<font color='NavajoWhite'>")
print("--------------------")
print("| radio playing... |")
print("--------------------")
if process_exists("softfm"):
    what = "FM radio is playing..."
else:
    if process_exists("dab-rtlsdr-2"):
        what = "DAB1 radio is playing..."
    else:
        if process_exists("welle-cli"):
            what = "DAB2 radio is playing..."
        else:
            if process_exists("vlc2"):
                what = "Random MP3 is playing..."
            else:
                if mpc1 == "" and mpc2 == "":
                    what = "Nothing is playing!"
                else:
                    what = "INTERNET radio is playing..."
                    if mpc1 == mpc2:
                        what = what + "\n\n" + mpc1
                    else:
                        what = what + "\n\n" + mpc1 + "\n" + mpc2
print(what)
print("<font color='Olive'>")
print("-----------")
print("| netstat |")
print("-----------")
print(netstat)
print("<font color='SpringGreen'>")
print("-----------------")
print("| wireless info |")
print("-----------------")
print(iwinfo)
print("")
print(ifconfig)
print("")
print(wireless)
print("")
print(statistics)
print("<font color='DodgerBlue'>")
print("----------")
print("| iostat |")
print("----------")
print(iostat)
print("<font color='Aqua'>")
print("-----------")
print("| free -h |")
print("-----------")
print(free)
print("<font color='Gold'>")
print("---------")
print("| df -h |")
print("---------")
print(df)
print("<font color='Peru'>")
print("-------")
print("| top |")
print("-------")
print(top)
print("</pre>")
print("</body>")
print("</html>")
