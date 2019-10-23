FROM alpine:3
RUN apk add --no-cache openjdk8 curl gettext

RUN mkdir -p /usr/local/bungee/data &&\
    cd /usr/local/bungee/ &&\
    curl -fLO 'http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar'

COPY config.yml /usr/local/bungee/
COPY entrypoint.sh /usr/local/bungee/bin/
RUN chmod +x /usr/local/bungee/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bungee/bin/entrypoint.sh"]

VOLUME /usr/local/bungee/data
WORKDIR /usr/local/bungee/data
CMD ["-jar", "/usr/local/bungee/BungeeCord.jar"]
EXPOSE 25565

