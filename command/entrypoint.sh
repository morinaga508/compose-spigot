#!/bin/bash
trap 'killall crond' SIGTERM

if [ "$1" != 'crond' ]; then
  exec "$@"
  exit $?
fi

/usr/local/bin/restore

"$@"

while pgrep crond > /dev/null ; do
  sleep 1
done

/usr/local/bin/mcstop nowait


