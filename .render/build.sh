#!/bin/bash
set -e
apt-get update -y
apt-get install -y unixodbc unixodbc-dev freetds-bin freetds-dev tdsodbc
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/odbc:$LD_LIBRARY_PATH
dpkg -l | grep -E 'unixodbc|freetds|tdsodbc' || echo "Packages not found"
find / -name libtdsodbc.so -print 2>/dev/null || echo "libtdsodbc.so not found"
find / -name libtdsS.so -print 2>/dev/null || echo "libtdsS.so not found"
echo "[FreeTDS]" > /etc/odbcinst.ini
echo "Description=FreeTDS Driver" >> /etc/odbcinst.ini
echo "Driver=$(find / -name libtdsodbc.so -print -quit 2>/dev/null)" >> /etc/odbcinst.ini
echo "Setup=$(find / -name libtdsS.so -print -quit 2>/dev/null)" >> /etc/odbcinst.ini
echo "TDS_Version=7.2" >> /etc/odbcinst.ini
cat /etc/freetds/freetds.conf
cat /etc/odbcinst.ini
odbcinst -j
pip install -r requirements.txt