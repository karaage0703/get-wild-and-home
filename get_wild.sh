#!/bin/sh

#MUSIC_PATH="/tmp/GetWild.m4a"

checkNoSleepCtrl()
{
  if [ ! -f $(which NoSleepCtrl) ]; then
    echo "Please install NoSleepCtrl from "
    echo "  https://github.com/integralpro/nosleep/releases"
    echo " "
    echo "Install it with CLI included in it. It's necessary to prevent"
    echo "your macbook from going to sleep when somebody closes the clamshell."
    echo "When you launch this script it will automatically turn the 'NoSleep'"
    echo "mode ON and when you exit the script with Ctrl-C, the 'NoSleep' mode"
    echo "will automatically be turned OFF."
    echo "(You are not required to be running it in the tray)"
    echo " "
    exit
  fi
}

forceVolume()
{
  local volume=$(osascript -e "(get volume settings)'s output volume")
  local muted=$(osascript -e "(get volume settings)'s output muted")
  while :; do
    NoSleepCtrl -a -s 1
    NoSleepCtrl -b -s 1
    osascript -e "set volume 100"
    sleep 0.1
  done &
  local pid=$!
  trap "
    NoSleepCtrl -a -s 0
    NoSleepCtrl -b -s 0
    kill $pid
    osascript -e 'set volume output volume $volume'
    osascript -e 'set volume output muted $muted'
    exit
  " SIGINT
}

isClamshellOpen()
{
  [ $(
    ioreg -r -k AppleClamshellState -d 4 |
    grep AppleClamshellState |
    head -1 |
    cut -d = -f 2
  ) = Yes ]
}

getWildAndTough()
{  
  # Check NoSleepCtrl available
  checkNoSleepCtrl

  # Init local variables
  local intrusion_detected=false
  local counter=0

  # Launch volume forcer
  forceVolume

  # Execution loop
  while :; do
    if (isClamshellOpen); then
#    if $intrusion_detected || $(isClamshellOpen); then
      let counter=5
			say -v Kyoko "また足手まといになっちゃったかな"
			sleep 1
			say -v Otoya "かおり"
			sleep 1
			say -v Kyoko "ん？"
			sleep 1
			say -v Otoya "お疲れさん"
			sleep 2
			say -v Kyoko "うん"

			echo "get wild"
			python ./get_wild.py
			/sbin/shutdown -h now
    fi
  done
}

getWildAndTough
