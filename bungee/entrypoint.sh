#!/bin/sh

if [ "$1" != '-jar' ]; then
  exec "$@"
  exit $?
fi

# Wait data
while [ ! -f ./active ]; do
  sleep 1
done

envsubst < ../config.yml > config.yml

exec java ${JAVA_OPTS} "$@"
