#!/bin/bash

#information
COIN_NAME='zelcash'
COIN_DAEMON='zelcashd'
COIN_CLI='zelcash-cli'
COIN_PATH='/usr/local/bin'
#end of required details

# add to path
PATH=$PATH:"$COIN_PATH"
export PATH

#Closing zelcash daemon and start reindex
sudo systemctl stop "$COIN_NAME" >/dev/null 2>&1 && sleep 3
"$COIN_CLI" stop >/dev/null 2>&1 && sleep 3
sudo killall "$COIN_DAEMON" >/dev/null 2>&1
sudo killall -s SIGKILL zelbenchd >/dev/null 2>&1
sleep 2

"$COIN_DAEMON" -reindex && sleep 60
if sudo systemctl list-units --full --no-legend --no-pager --plain --all --type service "$COIN_NAME.service" | grep -Foq "$COIN_NAME.service"; then
  sudo systemctl stop "$COIN_NAME" >/dev/null 2>&1 && sleep 3
  "$COIN_CLI" stop >/dev/null 2>&1 && sleep 3
  sudo killall "$COIN_DAEMON" >/dev/null 2>&1
  sudo killall -s SIGKILL zelbenchd >/dev/null 2>&1
  sleep 2
  sudo systemctl start "$COIN_NAME"
fi
