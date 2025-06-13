import pyodbc
from config import Config

try:
    # Establish connection
    conn = pyodbc.connect(Config.CONNECTION_STRING)
    
    # Create cursor
    cursor = conn.cursor()
    
    # Execute a simple test query
    cursor.execute("SELECT 1 AS test_value")
    row = cursor.fetchone()
    
    print("Connection successful! Test query returned:", row.test_value)
    
    # Close connection
    conn.close()
    
except pyodbc.Error as e:
    print("Connection failed!")
    print("Error message:", str(e))