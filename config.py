import pyodbc
import os

# class Config:
#     SQL_SERVER = '103.25.174.53'  # e.g., 'localhost' or 'server_ip'
#     DATABASE = 'pragatiweb'
#     USERNAME = 'sa'
#     PASSWORD = 'India@123456#'
#     DRIVER = '{ODBC Driver 17 for SQL Server}'
#     CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'

class Config:
    # Use os.environ.get() to read from environment variables
    SQL_SERVER = os.environ.get('DB_SERVER', 'default_server_if_local_dev')
    DATABASE = os.environ.get('DB_DATABASE', 'default_db_if_local_dev')
    USERNAME = os.environ.get('DB_USERNAME', 'default_user_if_local_dev')
    PASSWORD = os.environ.get('DB_PASSWORD', 'default_password_if_local_dev')
    DRIVER = '{ODBC Driver 17 for SQL Server}' # This can remain hardcoded or also be an env var

    CONNECTION_STRING = f'DRIVER={DRIVER};SERVER={SQL_SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'