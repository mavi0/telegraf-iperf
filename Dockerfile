From telegraf:1.31-alpine

RUN apk add --update --no-cache iperf3 speedtest-cli jq curl bash python3 && ln -sf python3 /usr/bin/python

