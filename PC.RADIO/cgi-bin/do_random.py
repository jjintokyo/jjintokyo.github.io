#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
import cgi, cgitb
import subprocess
import sqlite3
import os
import time

reload(sys)
sys.setdefaultencoding("Latin-1")
cgitb.enable()
form = cgi.FieldStorage()
what = form.getvalue("mySelection")
db_file = r"C:\PC.RADIO\yp.db"
sql_connection = sqlite3.connect(db_file)
sql_cursor = sql_connection.cursor()
sql_count_1 = """SELECT COUNT(*) FROM my_table;"""
sql_count_2 = """SELECT COUNT(*) FROM my_table WHERE genre LIKE ?;"""
sql_select_1 = """SELECT * FROM my_table ORDER BY RANDOM() LIMIT 1;"""
sql_select_2 = """SELECT * FROM my_table WHERE genre LIKE ? ORDER BY RANDOM() LIMIT 1;"""
mpc_error1 = "error: Failed to decode"
mpc_error2 = "error: No connection"

while True:
    if what == "Everything":
        sql_cursor.execute(sql_count_1)
        record = sql_cursor.fetchone()
        nb_records = str(record[0])
        sql_cursor.execute(sql_select_1)
    else:
        genre = "%" + str(what) + "%"
        genre = (genre,)
        sql_cursor.execute(sql_count_2, genre)
        record = sql_cursor.fetchone()
        nb_records = str(record[0])
        sql_cursor.execute(sql_select_2, genre)
    record = sql_cursor.fetchone()
    if record is None:
        url = "Nothing Found!"
        genre = "/"
        returned_output = ""
    else:
        url = record[0]
        genre = record[1]
        os.system(r"C:\PC.RADIO\mpc.exe del 41 > NUL")
        os.system(r"C:\PC.RADIO\mpc.exe add " + str(url) + " > NUL")
        command = r"C:\PC.RADIO\mpc.exe play 41"
        try:
            returned_output = subprocess.check_output(command, shell=False, stderr=subprocess.STDOUT)
        except Exception, e:
            returned_output = str(e.output)
        if mpc_error1.lower() in returned_output.lower():
            continue
        if mpc_error2.lower() in returned_output.lower():
            break
            ## os.system(r'start /MIN "Music Player Daemon" "C:\PC.RADIO\mpd.exe" "C:\PC.RADIO\mpd.conf" --kill --no-daemon --stderr --verbose')
            ## os.system(r"C:\PC.RADIO\mpc.exe stop > NUL")
            ## os.system(r"C:\PC.RADIO\mpc.exe clear > NUL")
            ## os.system(r'type "C:\PC.RADIO\playlist.db" | "C:\PC.RADIO\mpc.exe" add > NUL')
            ## continue
        time.sleep(1)
        command = r"C:\PC.RADIO\mpc.exe current"
        try:
            returned_output = subprocess.check_output(command, shell=False, stderr=subprocess.STDOUT)
        except Exception, e:
            returned_output = str(e.output)
        if mpc_error1.lower() in returned_output.lower():
            continue
    break

sql_cursor.close()
sql_connection.close()

try:
    genre_2 = unicode(str(genre))
except:
    genre_2 = str(genre.encode("Latin-1", "replace"))
try:
    returned_output_2 = unicode(str(returned_output))
except:
    returned_output_2 = str(returned_output.encode("Latin-1", "replace"))

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body BGCOLOR=Lavender TEXT=Black>")
print("<table border='0' cellpadding='0' cellspacing='0'>")
print("<tr>")
print("<td align='left'>")
print("<FONT SIZE=4 COLOR=Black>")
print("Random Web Radio..... <B>" + str(what) + "</B>" + "&nbsp;&nbsp;&nbsp;(" + str(nb_records) + " records found)")
print("</td>")
print("<td width='3%' rowspan='2'></td>")
print("<td rowspan='2' align='right'>")
print("<img src='/dancingalien.gif' alt='dancing alien' BORDER=0>")
print("</td>")
print("</tr>")
print("<tr>")
print("<td align='left'>")
print("<FONT SIZE=3 COLOR=Blue>")
print("<B>URL = " + url + "<BR>GENRE = " + genre_2 + "</B>")
print("</td>")
print("</tr>")
print("<tr>")
print("<td align='left'>")
print("<FONT SIZE=4 COLOR=Black>")
print("<h3><pre>" + returned_output_2 + "</pre></h3>")
print("</td>")
print("</tr>")
print("</table>")
print("</body>")
print("</html>")
