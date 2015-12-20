#!/bin/sh
if [ ! -f "/external_ip" ]; then
  if [ -z "$EXTERNAL_IP" ]; then
      curl http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null > /external_ip
  else
      echo $EXTERNAL_IP > /external_ip
  fi
fi

if [ ! -z "$TURN_CREDENTIALS" ]; then
    export TURN_CREDENTIALS=user:password
fi

if [ ! -z "$TURN_REALM" ]; then
    export TURN_REALM=domain.org
fi

exec /usr/bin/turnserver -n --log-file stdout --external-ip `cat /external_ip` -f -a --min-port 30000 --max-port 60000 -u $TURN_CREDENTIALS -v -r $TURN_REALM
