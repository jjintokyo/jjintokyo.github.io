#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import os
import sqlite3
import xml.etree.cElementTree as xml_et

db_file = "/tmp/ubi1/random/yp.db"
xml_file = "/tmp/ubi1/random/yp.xml"
if os.path.isfile(db_file): os.remove(db_file)

sql_connection = sqlite3.connect(db_file)
sql_cursor = sql_connection.cursor()
sql_create = """CREATE TABLE IF NOT EXISTS my_table (url text, genre text);"""
sql_insert = """INSERT INTO my_table (url, genre) VALUES (?, ?);"""
sql_cursor.execute(sql_create)

xml_tree = xml_et.parse(xml_file)
xml_root = xml_tree.getroot()

for element in xml_root:
    for sub_element in element:
        if sub_element.tag == 'listen_url': url = sub_element.text
        if sub_element.tag == 'genre': genre = sub_element.text
    sql_cursor.execute(sql_insert, (url, genre))

sql_connection.commit()
sql_cursor.close()
sql_connection.close()
