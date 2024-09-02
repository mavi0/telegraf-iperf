#!/usr/bin/env bash

# This script measures network performance using iperf3 and speedtest-cli.
# It retrieves download and upload speeds from both iperf3 and speedtest-cli,
# as well as the ping latency from speedtest-cli.
# The results are then formatted into a JSON object and printed to the console.

# ${IPERF_SERVER} is an environment variable set when container is instantiated.
# See: https://docs.docker.com/compose/environment-variables/set-environment-variables/

# Iperf UDP Testing
# Dpwnload
iperf_dl_udp_a=$(iperf3 --client ${IPERF_SERVER_A} --json --reverse --omit 5 -b 1000M -u)
iperf_dl_udp_a=$(echo $iperf_dl_udp_a| jq .end.sum_received.bits_per_second)
iperf_dl_udp_b=$(iperf3 --client ${IPERF_SERVER_B} --json --reverse --omit 5 -b 1000M -u)
iperf_dl_udp_b=$(echo $iperf_dl_udp_b | jq .end.sum_received.bits_per_second)
# Upload
iperf_ul_udp_a=$(iperf3 --client ${IPERF_SERVER_A} --json --omit 5 -b 1000M -u)
iperf_ul_udp_a=$(echo $iperf_ul_udp_a | jq .end.sum_received.bits_per_second)
iperf_ul_udp_b=$(iperf3 --client ${IPERF_SERVER_B} --json --omit 5 -b 1000M -u)
iperf_ul_udp_b=$(echo $iperf_ul_udp_b | jq .end.sum_received.bits_per_second)

# Iperf TCP Testing
# Download
iperf_dl_tcp_a=$(iperf3 --client ${IPERF_SERVER_A} --json --reverse --omit 5 -P30 -t10 --json)
iperf_dl_tcp_a=$(echo $iperf_dl_tcp_a | jq .end.sum_received.bits_per_second)
iperf_dl_tcp_b=$(iperf3 --client ${IPERF_SERVER_B} --json --reverse --omit 5 -P30 -t10 --json)
iperf_dl_tcp_b=$(echo $iperf_dl_tcp_b | jq .end.sum_received.bits_per_second)
# Upload
iperf_ul_tcp_a=$(iperf3 --client ${IPERF_SERVER_A} --json --omit 5 -P30 -t10 --json)
iperf_ul_tcp_a=$(echo $iperf_ul_tcp_a | jq .end.sum_received.bits_per_second)
iperf_ul_tcp_b=$(iperf3 --client ${IPERF_SERVER_B} --json --omit 5 -P30 -t10 --json)
iperf_ul_tcp_b=$(echo $iperf_ul_tcp_b | jq .end.sum_received.bits_per_second)

# Ookla Speedtest
ookla=$(speedtest-cli --json)  
ookla_download=$(echo $ookla | jq '.download')
ookla_upload=$(echo $ookla | jq '.upload')
ookla_ping=$(echo $ookla | jq '.ping')

# Sanitise vars
iperf_dl_udp_a=${iperf_dl_udp_a:=0}
iperf_dl_udp_b=${iperf_dl_udp_b:=0}
iperf_ul_udp_a=${iperf_ul_udp_a:=0}
iperf_ul_udp_b=${iperf_ul_udp_b:=0}
iperf_dl_tcp_a=${iperf_dl_tcp_a:=0}
iperf_dl_tcp_b=${iperf_dl_tcp_b:=0}
iperf_ul_tcp_a=${iperf_ul_tcp_a:=0}
iperf_ul_tcp_b=${iperf_ul_tcp_b:=0}
ookla_download=${ookla_download:=0}
ookla_upload=${ookla_upload:=0}
ookla_ping=${ookla_ping:=0}

# Format the results into a JSON object
echo "{
    \"iperf_dl_udp_a\": $iperf_dl_udp_a,
    \"iperf_dl_udp_b\": $iperf_dl_udp_b,
    \"iperf_ul_udp_a\": $iperf_ul_udp_a,
    \"iperf_ul_udp_b\": $iperf_ul_udp_b,
    \"iperf_dl_tcp_a\": $iperf_dl_tcp_a,
    \"iperf_dl_tcp_b\": $iperf_dl_tcp_b,
    \"iperf_ul_tcp_a\": $iperf_ul_tcp_a,
    \"iperf_ul_tcp_b\": $iperf_ul_tcp_b,
    \"ookla_download\": $ookla_download,
    \"ookla_upload\": $ookla_upload,
    \"ookla_ping\": $ookla_ping
}"
