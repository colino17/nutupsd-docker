#!/bin/sh

mkdir -p /var/run/nut

echo "[ups]" > /etc/nut/ups.conf
echo "driver = $UPS_DRIVER" >> /etc/nut/ups.conf
echo "port = $UPS_PORT" >> /etc/nut/ups.conf

echo "[$UPS_USER]" > /etc/nut/upsd.users
echo "password = $UPS_PASSWORD" >> /etc/nut/upsd.users
echo "upsmon primary" >> /etc/nut/upsd.users
echo "actions = SET" >> /etc/nut/upsd.users
echo "instcmds = ALL" >> /etc/nut/upsd.users

echo "MONITOR ups@localhost 1 $UPS_USER $UPS_PASSWORD primary" > /etc/nut/upsmon.conf

echo 0 > /var/run/nut/upsd.pid && chown nut:nut /var/run/nut/upsd.pid
echo 0 > /var/run/upsmon.pid

chgrp -R nut /etc/nut /dev/bus/usb /var/run/nut
chmod -R o-rwx /etc/nut 

upsdrvctl start
upsd
upsmon -D
