echo #!/bin/bash > .render\build.sh
echo apt-get update >> .render\build.sh
echo apt-get install -y unixodbc unixodbc-dev freetds-bin freetds-dev tdsodbc >> .render\build.sh
echo echo \"[FreeTDS]\" \> /etc/odbcinst.ini >> .render\build.sh
echo echo \"Description=FreeTDS ODBC Driver\" \>> /etc/odbcinst.ini >> .render\build.sh
echo echo \"Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so\" \>> /etc/odbcinst.ini >> .render\build.sh
echo echo \"Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so\" \>> /etc/odbcinst.ini >> .render\build.sh
echo echo \"TDS_Version=7.4\" \>> /etc/odbcinst.ini >> .render\build.sh
echo pip install -r requirements.txt >> .render\build.sh
chmod +x .render\build.sh