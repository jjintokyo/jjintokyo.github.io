#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sqlite3
import sys
import os

if os.path.isfile("/tmp/yp.db"):
    db_file = "/tmp/yp.db"
else:
    if os.path.isfile("/mnt/sda1/random/yp.db"):
        db_file = "/mnt/sda1/random/yp.db"
    else:
        print "Nothing Found!"
        sys.exit(0)

sql_connection = sqlite3.connect(db_file)
sql_cursor = sql_connection.cursor()
sql_select_1 = """SELECT * FROM my_table ORDER BY genre;"""
sql_select_2 = """SELECT * FROM my_table WHERE genre LIKE ? ORDER BY genre;"""

parameter = str(sys.argv[1]) if len(sys.argv) > 1 else ""
if parameter == "" or parameter == "Everything":
    sql_cursor.execute(sql_select_1)
else:
    genre = "%" + parameter + "%"
    genre = (genre,)
    sql_cursor.execute(sql_select_2, genre)

records = sql_cursor.fetchall()
for row in records:
    if row[0] != None: print row[0]

sql_cursor.close()
sql_connection.close()
