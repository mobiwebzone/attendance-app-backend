#!/bin/bash
set -e  # Exit on error
apt-get update
apt-get install -y unixodbc unixodbc-dev freetds-bin freetds-dev tdsodbc
# Debug: Check installed packages
dpkg -l | grep -E 'unixodbc|freetds|tdsodbc' || echo "Packages not found"
# Debug: Find library paths
find /usr -name libtdsodbc.so -print || echo "libtdsodbc.so not found"
find /usr -name libtdsS.so -print || echo "libtdsS.so not found"
# Configure odbcinst.ini
echo "[FreeTDS]" > /etc/odbcinst.ini
echo "Description=FreeTDS ODBC Driver" >> /etc/odbcinst.ini
echo "Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so" >> /etc/odbcinst.ini
echo "Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" >> /etc/odbcinst.ini
echo "TDS_Version=7.4" >> /etc/odbcinst.ini
# Debug: Verify odbcinst.ini
cat /etc/odbcinst.ini
# Debug: ODBC config
odbcinst -j
pip install -r requirements.txt