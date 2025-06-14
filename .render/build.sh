#!/bin/bash
set -e
apt-get update
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc
dpkg -l | grep -E 'msodbcsql|unixodbc' || echo "Packages not found"
odbcinst -j
find /opt -name 'msodbcsql*.so' -print || echo "msodbcsql.so not found"
cat /etc/odbcinst.ini
pip install -r requirements.txt