# import pyodbc

# class Config:
#     SQL_SERVER = '103.25.174.53'  # e.g., 'localhost' or 'server_ip'
#     DATABASE = 'pragatiweb'
#     USERNAME = 'sa'
#     PASSWORD = 'India@123456#'
#     DRIVER = '{ODBC Driver 17 for SQL Server}'
#     CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'
import os

class Config:
    SQL_SERVER = os.getenv('SQL_SERVER', '103.25.174.53')
    DATABASE = os.getenv('DATABASE', 'pragatiweb')
    USERNAME = os.getenv('DB_USERNAME')
    PASSWORD = os.getenv('DB_PASSWORD')
    DRIVER = '{ODBC Driver 17 for SQL Server}'
    CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};PORT=1433;DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'