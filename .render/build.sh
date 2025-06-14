#!/bin/bash
set -e  # Exit on error
apt-get update
apt-get install -y unixodbc unixodbc-dev freetds-bin freetds-dev tdsodbc
# Verify FreeTDS installation
ls -l /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so || echo "libtdsodbc.so not found"
ls -l /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so || echo "libtdsS.so not found"
# Configure odbcinst.ini
echo "[FreeTDS]" > /etc/odbcinst.ini
echo "Description=FreeTDS ODBC Driver" >> /etc/odbcinst.ini
echo "Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so" >> /etc/odbcinst.ini
echo "Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" >> /etc/odbcinst.ini
echo "TDS_Version=7.4" >> /etc/odbcinst.ini
# Debug odbcinst.ini
cat /etc/odbcinst.ini
pip install -r requirements.txt