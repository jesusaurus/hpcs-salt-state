#! /bin/sh
#
### BEGIN INIT INFO
# Provides:          tinc
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Should-Start:      $syslog $named
# Should-Stop:       $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start tinc daemons
# Description:       Create a file $NETSFILE (/etc/tinc/nets.boot),
#                    and put all the names of the networks in there.
#                    These names must be valid directory names under
#                    $TCONF (/etc/tinc). Lines starting with a # will be
#                    ignored in this file.
### END INIT INFO
#
# Based on Lubomir Bulej's Redhat init script.

DAEMON="/usr/sbin/tincd"
NAME="tinc"
DESC="tinc daemons"
TCONF="/etc/tinc"
NETSFILE="$TCONF/nets.boot"
NETS=""

EXTRA=" -d3" # debugging level = 3

test -f $DAEMON || exit 0

[ -r /etc/default/tinc ] && . /etc/default/tinc

# foreach_net "what-to-say" action [arguments...]
foreach_net() {
  if [ ! -f $NETSFILE ] ; then
    echo "Please create $NETSFILE."
    exit 0
  fi
  echo -n "$1"
  shift
  egrep '^[ ]*[a-zA-Z0-9_-]+' $NETSFILE | while read net args; do
    echo -n " $net"
    "$@" $net $args
  done
  echo "."
}

signal_running() {
  for i in /var/run/tinc.*pid; do
    if [ -f "$i" ]; then
      head -1 $i | while read pid; do
        kill -$1 $pid
      done
    fi
  done
}

check_running() {
  if [ -f "/var/run/tinc.$1.pid" ]; then
    head -1 /var/run/tinc.$1.pid | while read pid; do
      kill -0 $pid
      if $?; then
        echo " running with pid $pid"
      else
        echo " not running"
        exit -1
      fi
    done
  fi
}

start() {
  $DAEMON $EXTRA -n "$@"
}
stop() {
  $DAEMON -n $1 -k
}
reload() {
  $DAEMON -n $1 -kHUP
}
alarm() {
  $DAEMON -n $1 -kALRM
}
restart() {
  stop "$@"
  sleep 0.5
  i=0;
  while [ -f /var/run/tinc.$1.pid ] ; do
        if [ $i = '10' ] ; then
                break
        else
                echo -n "."
                sleep 0.5
                i=$(($i+1))
        fi
  done
  start "$@"
}

case "$1" in
  start)
    foreach_net "Starting $DESC:" start
  ;;
  stop)
    foreach_net "Stopping $DESC:" stop
  ;;
  reload|force-reload)
    foreach_net "Reloading $DESC configuration:" reload
  ;;
  restart)
    foreach_net "Restarting $DESC:" restart
  ;;
  alarm)
    signal_running ALRM
  ;;
  status)
    foreach_net "Checking $DESC status:\n" check_running
  ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|reload|restart|force-reload|alarm}"
    exit 1
  ;;
esac

exit 0
