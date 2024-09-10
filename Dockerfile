From telegraf:1.31-alpine

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache iperf3 speedtest-cli jq curl bash python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
