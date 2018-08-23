# oracledbconnect.py

from __future__ import print_function

import cx_Oracle

# Connect as user "hr" with password "welcome" to the "oraclepdb" service running on this computer.
connection = cx_Oracle.connect("myuser", "mypassword", "host/servicename")

cursor = connection.cursor()
cursor.execute("""
    SELECT table_name
    FROM user_tables 
    ORDER BY table_name"""
    )
for tablename in cursor:
    print("Values:", tablename)
