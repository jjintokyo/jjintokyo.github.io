#!/usr/bin/python3
# -*- coding: utf-8 -*-
# ln /root/random/yp.db /var/www/html/

import cgi, cgitb, os, sqlite3, subprocess, time

cgitb.enable()
form = cgi.FieldStorage()
what = form.getvalue("random_selection")
if what is None:
    what = "Everything"
os.system("/usr/lib/cgi-bin/stop.py AAA")
db_file = "/var/www/html/yp.db"
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
        os.system("/usr/bin/mpc del 41 &>/dev/null")
        os.system("/usr/bin/mpc add " + str(url) + " &>/dev/null")
        command = "/usr/bin/mpc play 41 &>/dev/null"
        try:
            returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        except Exception as e:
            returned_output = e.output
        if mpc_error1.lower() in returned_output.decode('utf8').lower():
            continue
        if mpc_error2.lower() in returned_output.decode('utf8').lower():
            break
        time.sleep(1)
        command = "/usr/bin/mpc status"
        try:
            returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        except Exception as e:
            returned_output = e.output
        if mpc_error1.lower() in returned_output.decode('utf8').lower():
            continue
    break

sql_cursor.close()
sql_connection.close()
if returned_output:
    returned_output = str(returned_output.decode('utf8', errors='replace'))

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
print("<table border='0' cellpadding='0' cellspacing='0'>")
print("<tr>")
print("<td align='left'>")
print("<font size=5>")
print("Random Web Radio..... <b>" + str(what) + "</b>" + "&nbsp;&nbsp;&nbsp;(" + str(nb_records) + " records found)<br><br>")
print("</td>")
print("</tr>")
print("<tr>")
print("<td align='left'>")
print("<font size=3>")
print("<b>URL = " + str(url) + "<br>GENRE = " + str(genre) + "</b><br><br>")
print("</td>")
print("</tr>")
print("<tr>")
print("<td align='left'>")
print("<font size=4>")
print("<h3><pre>" + str(returned_output) + "</pre></h3>")
print("</td>")
print("</tr>")
print("</table>")
print("</body>")
print("</html>")
