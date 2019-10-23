#!/bin/bash
trap 'mcrcon stop' SIGTERM

if [ "$1" != '-jar' ]; then
  exec "$@"
  exit $?
fi

# Wait data
echo "Waiting for world data"
while [ ! -f ./active ]; do
  sleep 1
done
ls -l ./active

# RCON
test -f eula.txt || java $@ || true
sed -i -e 's/^eula=.*/eula='${EULA:-false}'/g' eula.txt
sed -i -e "s/^enable-rcon=.*/enable-rcon=true/g" server.properties
sed -i -e "s/^rcon\.password=.*/rcon.password=${MCRCON_PASS}/g" server.properties
sed -i -e "s/^online-mode=.*/online-mode=false/g" server.properties
sed -i -e "s/^enable-command-block=.*/enable-command-block=${COMMANDBLOCK}/g" server.properties
sed -i -e "s/^white-list=.*/white-list=true/g" server.properties

cat server.properties

#RUN
screen -AmdS minecraft java ${JAVA_OPTS} "$@" 
sleep 10
echo "Waiting for spigot"
until mcrcon pl	; do
  pgrep java
  test $? -ne 0 && exit 1
  sleep 5
done

echo "Spigot is up - executing command" 1>&2
test "$WHITE_LIST" != 'true' && mcrcon 'whitelist off'

while pgrep java > /dev/null ; do
  sleep 1
done

rm -f ./active
tail -n 1 logs/latest.log | grep 'All chunks are saved' || exit 1
