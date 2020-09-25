#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
import os
import subprocess
import sqlite3
import time

class colors:
    GREEN   = "\033[92m"
    BLUE    = "\033[94m"
    RED     = "\033[91m"
    PURPLE  = "\033[95m"
    REVERSE = "\033[7m"
    END     = "\033[0m"

reload(sys)
sys.setdefaultencoding("Latin-1")
os.system("")
db_file = r"C:\PC.RADIO\yp.db"
sql_connection = sqlite3.connect(db_file)
sql_cursor = sql_connection.cursor()
sql_count_1 = """SELECT COUNT(*) FROM my_table;"""
sql_count_2 = """SELECT COUNT(*) FROM my_table WHERE genre LIKE ?;"""
sql_select_1 = """SELECT * FROM my_table ORDER BY RANDOM() LIMIT 1;"""
sql_select_2 = """SELECT * FROM my_table WHERE genre LIKE ? ORDER BY RANDOM() LIMIT 1;"""
mpc_error1 = "error: Failed to decode"
mpc_error2 = "error: No connection"
nb = 0

if len(sys.argv) > 2:
    what = str(sys.argv[1])
    sleep = str(sys.argv[2])
else:
    what = "Everything"
    sleep = "10"

if what == "Everything":
    sql_cursor.execute(sql_count_1)
else:
    genre = "%" + str(what) + "%"
    genre = (genre,)
    sql_cursor.execute(sql_count_2, genre)

record = sql_cursor.fetchone()
nb_records = str(record[0])

while True:
    if what == "Everything":
        sql_cursor.execute(sql_select_1)
    else:
        genre = "%" + str(what) + "%"
        genre = (genre,)
        sql_cursor.execute(sql_select_2, genre)
    record = sql_cursor.fetchone()
    if record is None:
        print("Nothing Found!")
        break
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
        os.system(r'start /MIN "Music Player Daemon" "C:\PC.RADIO\mpd.exe" "C:\PC.RADIO\mpd.conf" --kill --no-daemon --stderr --verbose')
        os.system(r"C:\PC.RADIO\mpc.exe stop > NUL")
        os.system(r"C:\PC.RADIO\mpc.exe clear > NUL")
        os.system(r'type "C:\PC.RADIO\playlist.db" | "C:\PC.RADIO\mpc.exe" add > NUL')
        continue
    time.sleep(1)
    command = r"C:\PC.RADIO\mpc.exe current"
    try:
        returned_output = subprocess.check_output(command, shell=False, stderr=subprocess.STDOUT)
    except Exception, e:
        returned_output = str(e.output)
    if mpc_error1.lower() in returned_output.lower():
        continue
    try:
        nb += 1
        print(colors.GREEN + "#" + str(nb) + "    Random " + str(what) + "   (" + str(nb_records) + " records found)   sleep " + str(sleep) + " seconds" + colors.END)
        print(colors.BLUE + "URL   = " + str(url) + colors.END)
        print(colors.RED + "GENRE = " + str(genre.decode("Latin-1", "ignore")) + colors.END)
        print(colors.PURPLE + "TITLE = " + str(returned_output.decode("Latin-1", "ignore")) + colors.END)
        print("")
        time.sleep(int(sleep))
    except:
        print(colors.REVERSE + "***** ERROR *****" + colors.END)
        print("")
