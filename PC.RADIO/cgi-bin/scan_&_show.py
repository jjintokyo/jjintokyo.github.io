#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import time
import sys
import os
import socket
import codecs
import sqlite3
import re
import struct
import urllib2

class colors:
    GREEN   = "\033[92m"
    BLUE    = "\033[94m"
    RED     = "\033[91m"
    PURPLE  = "\033[95m"
    REVERSE = "\033[7m"
    END     = "\033[0m"

def build_report(nb, nb_records, url, genre, title):
    try:
        print(colors.GREEN + "#" + str(nb) + "    Random " + str(what) + "   (" + str(nb_records) + " records found)" + colors.END)
        print(colors.BLUE + "URL   = " + str(url) + colors.END)
        print(colors.RED + "GENRE = " + str(genre.decode("Latin-1", "ignore")) + colors.END)
        print(colors.PURPLE + "TITLE = " + str(title.decode("Latin-1", "ignore")) + colors.END)
        print("")
        file.write("#" + str(nb) + "    Random " + str(what) + "   (" + str(nb_records) + " records found)")
        file.write("\n")
        file.write("URL   = " + str(url))
        file.write("\n")
        file.write("GENRE = " + str(genre.decode("Latin-1", "ignore")))
        file.write("\n")
        file.write("TITLE = " + str(title.decode("Latin-1", "ignore")))
        file.write("\n\n")
    except:
        print(colors.REVERSE + "***** ERROR *****" + colors.END)
        print("")
        file.write("***** ERROR *****")
        file.write("\n\n")

start_time = time.time()
reload(sys)
sys.setdefaultencoding("Latin-1")
os.system("")
socket.setdefaulttimeout(60)
output_file = r"C:\PC.RADIO\scan_&_show.txt"
file = codecs.open(output_file, "w", "utf-8")
db_file = r"C:\PC.RADIO\yp.db"
sql_connection = sqlite3.connect(db_file)
sql_cursor = sql_connection.cursor()
sql_select_1 = """SELECT * FROM my_table ORDER BY RANDOM();"""
sql_select_2 = """SELECT * FROM my_table WHERE genre LIKE ? ORDER BY RANDOM();"""
no_details = "No Details Available!"
no_title = "No Title Found!"
nb = 0

if len(sys.argv) > 1:
    what = str(sys.argv[1])
else:
    what = "Everything"

if what == "Everything":
    sql_cursor.execute(sql_select_1)
else:
    genre = "%" + str(what) + "%"
    genre = (genre,)
    sql_cursor.execute(sql_select_2, genre)

records = sql_cursor.fetchall()
nb_records = len(records)

if nb_records == 0:
    print("Nothing Found!")
    sys.exit(0)

for row in records:
    nb += 1
    url = row[0]
    genre = row[1]
    try:
        request = urllib2.Request(url, headers={'Icy-MetaData': 1})
    except:
        title = no_details
        build_report(nb, nb_records, url, genre, title)
        continue
    try:
        response = urllib2.urlopen(request)
    except:
        title = no_details
        build_report(nb, nb_records, url, genre, title)
        continue
    details = str(response.headers)
    try:
        metaint = int(response.headers['icy-metaint'])
    except:
        title = no_title
        build_report(nb, nb_records, url, genre, title)
        continue
    for _ in range(10):
        try:
            response.read(metaint)
            metadata_length = struct.unpack('B', response.read(1))[0] * 16
            metadata = response.read(metadata_length).rstrip(b'\0')
            details = details + str(metadata)
        except:
            title = no_title
            break
        start = "StreamTitle='"
        end = "';"
        try:
            title = re.search('%s(.*)%s' % (start, end), metadata).group(1)
            title = re.sub("StreamUrl='.*?';", "", title).replace("';", "").replace("StreamUrl='", "")
            title = re.sub("&artist=.*", "", title)
            title = re.sub("http://.*", "", title)
            title.rstrip()
        except:
            title = no_title
        if title:
            break
        else:
            title = no_title
    build_report(nb, nb_records, url, genre, title)
    continue

sql_cursor.close()
sql_connection.close()
end_time = time.time()
print(colors.PURPLE + "Runtime (in seconds): {}".format(int(end_time - start_time)) + colors.END)
print("")
file.write("Runtime (in seconds): {}".format(int(end_time - start_time)))
file.write("\n\n")
file.close()
os.system("pause")
