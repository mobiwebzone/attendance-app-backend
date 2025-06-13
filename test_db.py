import pyodbc
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=103.25.174.53;DATABASE=pragatiweb;UID=sa;PWD=India@123456#')
print("Connection successful")
conn.close()