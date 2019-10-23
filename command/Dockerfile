FROM alpine:3 AS mcrconbuild
RUN apk add --no-cache gcc musl-dev git &&\
    mkdir -p /usr/local/src &&\
    cd /usr/local/src &&\
    git clone https://github.com/Tiiffi/mcrcon.git &&\
    cd mcrcon  &&\
    gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

FROM alpine:3
RUN apk add --no-cache mysql-client py2-pip bash &&\
    mkdir -p /usr/local/bin &&\
    pip install mcstatus &&\
    pip install awscli &&\
    echo '30 * * * * /usr/local/bin/mcbackup main wait' >> /etc/crontabs/root &&\
    echo '31 * * * * /usr/local/bin/mcbackup hub wait' >> /etc/crontabs/root &&\
    echo '32 * * * * /usr/local/bin/bungeebackup' >> /etc/crontabs/root

COPY --from=mcrconbuild /usr/local/src/mcrcon/mcrcon /usr/local/bin
COPY bungeebackup /usr/local/bin/
COPY restore /usr/local/bin/
COPY mcbackup /usr/local/bin/
COPY mcstop /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["crond"]
WORKDIR /tmp
