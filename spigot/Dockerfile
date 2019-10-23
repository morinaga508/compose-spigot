FROM alpine:3 AS builder
ARG mcver

RUN apk add --no-cache openjdk10-jre-headless curl git
RUN mkdir -p /usr/local/src &&\
    cd /usr/local/src &&\
    curl -fLO https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar &&\
    java -jar BuildTools.jar --rev ${mcver} &&\
    mv spigot-${mcver}.jar spigot.jar

RUN apk add --no-cache gcc musl-dev &&\
    cd /usr/local/src &&\
    git clone https://github.com/Tiiffi/mcrcon.git &&\
    cd mcrcon &&\
    gcc -static -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

FROM alpine:3
RUN apk add --no-cache bash openjdk10-jre-headless mysql-client screen py2-pip &&\
    pip install mcstatus

RUN mkdir -p /usr/local/spigot \
             /usr/local/bin
COPY --from=builder /usr/local/src/spigot.jar /usr/local/spigot/
COPY --from=builder /usr/local/src/mcrcon/mcrcon /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV DOLLAR='$'
ENV MCRCON_HOST 127.0.0.1
ENV MCRCON_PASS rconpass
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD mcstatus localhost ping || exit 1
WORKDIR /usr/local/spigot/data
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["-jar", "/usr/local/spigot/spigot.jar"]
VOLUME /usr/local/spigot/data/
EXPOSE 25565
