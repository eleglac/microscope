#!/bin/bash

# This script polls for key events and will automatically take
# and send a picture to a given email address (arg 1 to this script)
# when 'p' is pressed.  Meant to work in tandem with the 'microscope'
# script.  This is meant to work on the Raspberry Pi, using the 
# 'raspistill' utility.
#
# Use of this script requires mpack.
#
# Credit to Franklin52 on the unix.com forums for the keypress polling
# code.  The remainder of the script was written by Alex J. Ponting.


_send-picture() {
  # Creates and attempts to email an image to a provided
  # email address.

  OF=microscope-image-$(date +%s).png
  raspistill -o $OF -w 1920 -h 1080

  echo "sending email..."
  mpack -s "Microscope Picture" $OF $1
  echo "sent okay"
}

_key-press() {
  # Detects a key press, and returns the pressed key.

  local kp
  ESC=$'\e'
  _KEY=
  read -d '' -sn1 _KEY
  case $_KEY in
    "$ESC")
       while read -d '' -sn1 -t1 kp
       do
	 _KEY=$_KEY$KP
         case $kp in
           [a-zA-NP-Z~]) break;;
         esac
       done
    ;;
  esac
  printf -v "${1:-_KEY}" "%s" "$_KEY"
}

# The actual meat.  Collects an email address, starts up
# a raspivid instance, then waits for keypress to kill
# raspivid, take a picture, then bring raspivid back up.
# Suuuuper elegant and def. not a hack at all.

clear

echo "To what email address should I send pictures?"
read EMAIL
while [ -z $EMAIL ]; do
  echo "Gotta give me something!"
  read EMAIL
done
echo "Thanks, I'll send pictures to $EMAIL"
echo "Starting camera... "

raspivid -t 0 -fps 25.2 &

while [ 1 = 1 ]; do
  
  _key-press x

  case $x in
	$'\[11~' | $'\e[OP') key=F1 ;;
	$'\[12~' | $'\e[OR') key=F2 ;;
	$'\[13~' | $'\e[OQ') key=F3 ;;
	$'\[14~' | $'\e[OS') key=F4 ;;
        $'\[15~') key=F5 ;;
        $'\[16~') key=F6 ;;
        $'\[17~') key=F7 ;;
        $'\[18~') key=F8 ;;
        $'\[19~') key=F9 ;;
        $'\[20~') key=F10 ;;
        $'\[21~') key=F11 ;;
        $'\[22~') key=F12 ;;
        $'\[A~') key=UP ;;
        $'\[B~') key=DOWN ;;
        $'\[C~') key=RIGHT ;;
        $'\[D~') key=LEFT ;;
	?) key=$x ;;
        *) key=??? ;;
  esac

  if [ $key = 'p' ]; then
    PROCS=$(ps | grep "raspivid")
    VID_ID=$(echo $PROCS | cut -d' ' -f 1)

    kill -9 $VID_ID
    #_send-picture $EMAIL

    raspivid -t 0 -fps 25.2
  fi

done