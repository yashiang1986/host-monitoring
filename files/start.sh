#!/bin/bash
. /opt/netdata/functions.sh
restart_netdata >run.log 2>&1
sleep infinity
