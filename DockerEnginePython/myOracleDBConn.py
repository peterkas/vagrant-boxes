# myOracleDBConn.py

from __future__ import print_function

import cx_Oracle

connection = cx_Oracle.connect("user", "password", "(DESCRIPTION = (ADDRESS = (PROTOCOL = TCPS)(HOST = adwc.uscom-east-1.oraclecloud.com)(PORT = 1522))(ADDRESS = (PROTOCOL = TCPS)(HOST = adwc.uscom-east-1.oraclecloud.com)(PORT = 1522))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = bhuzeszqvf4hrf7_db201807201207_medium.adwc.oraclecloud.com)))")

cursor = connection.cursor()
cursor.execute("""
    SELECT table_name
    FROM user_tables 
    ORDER BY table_name"""
    )
for tablename in cursor:
    print("Values:", tablename)
