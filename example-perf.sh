#!/usr/bin/env bash

# This script measures network performance using iperf3 and speedtest-cli.
# It retrieves download and upload speeds from both iperf3 and speedtest-cli,
# as well as the ping latency from speedtest-cli.
# The results are then formatted into a JSON object and printed to the console.

iperf_dl=$(iperf3 --client ${IPERF_SERVER} --json --reverse --omit 5)
iperf_download=$(echo $iperf_dl | jq .end.sum_received.bits_per_second)

iperf_ul=$(iperf3 --client ${IPERF_SERVER} --json --omit 5)
iperf_upload=$(echo $iperf_ul | jq .end.sum_received.bits_per_second)

ookla=$(speedtest-cli --json)  

ookla_download=$(echo $ookla | jq '.download')
ookla_upload=$(echo $ookla | jq '.upload')
ookla_ping=$(echo $ookla | jq '.ping')

# Format the results into a JSON object
echo "{\"iperf_download\":$iperf_download,\"iperf_upload\":$iperf_upload, \"ookla_download\":$ookla_download, \"ookla_upload\":$ookla_upload, \"ookla_ping\":$ookla_ping}"
