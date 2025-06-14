#!/bin/bash
set -e  # Exit on error
apt-get update
# Add Microsoft repository
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
# Install ODBC driver
ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc
# Debug: Verify driver installation
dpkg -l | grep -E 'msodbcsql|unixodbc' || echo "Packages not found"
odbcinst -j
find /opt -name 'msodbcsql*.so' -print || echo "msodbcsql.so not found"
cat /etc/odbcinst.ini
# Install Python dependencies
pip install -r requirements.txt