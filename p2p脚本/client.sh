#!/bin/sh
export CLIENT_UUID="-m 00000000-0000-0000-0000-00000010001a"
# mac[1,8]-mac[9,12]-mac[1,4]-mac[5,8]-mac[9,12]mac[1,8]
#export NAS_UUID="-M 2497ed0d-63e6-2497-ed0d-63e62497ed0d"
#export NAS_UUID="-M 00102030-4051-0010-2030-405100102030"
#export NAS_UUID="-M 2497ed0d-63e6-2497-ed0d-63e62497ed0d"
#export NAS_UUID="-M 2497ed12-19e8-2497-ed12-19e82497ed12"
#export NAS_UUID="-M 2497ed0d-63f6-2497-ed0d-63f62497ed0d"
#export NAS_UUID="-M 2497ed12-19e8-2497-ed12-19e82497ed12"
#export NAS_UUID="-M 2497ed0d-63e0-2497-ed0d-63e02497ed0d"
#export NAS_UUID="-M 2497ed0e-83a9-2497-ed0e-83a92497ed0e"
#export NAS_UUID="-M 2497ed0c-12dc-2497-ed0c-12dc2497ed0c"
#export NAS_UUID="-M 2497ed0e-83a9-2497-ed0e-83a92497ed0e"
#export NAS_UUID="-M 2497ed0d-640d-2497-ed0d-640d2497ed0d"
#export NAS_UUID="-M 2497ed0d-63e8-2497-ed0d-63e82497ed0d"
#export NAS_UUID="-M 2497ed0d-63e7-2497-ed0d-63e72497ed0d"
#export NAS_UUID="-M 6eff5f0d-9792-6eff-5f0d-97926eff5f0d"
#export NAS_UUID="-M 4209624e-40d3-4209-624e-40d34209624e"
#export NAS_UUID="-M 2497ed12-1a00-2497-ed12-1a002497ed12"
#export NAS_UUID="-M 00a0c9ee-0155-00a0-c9ee-015500a0c9ee"
#export NAS_UUID="-M e4671e1a-3e54-e467-1e1a-3e54e4671e1a"
export NAS_UUID="-M 681def29-87d0-681d-ef29-87d0681def29"

mac=$1
if [ -n "${mac}" ]; then
	lower_mac=`echo -n ${mac} | tr A-Z a-z | sed 's/[^a-z0-9]//g'`
	uuid="${lower_mac:0:8}-${lower_mac:8:4}-${lower_mac:0:4}-${lower_mac:4:4}-${lower_mac:8:4}${lower_mac:0:8}"
	echo "========================uuid: ${uuid}============================"
	export NAS_UUID="-M ${uuid}"
fi

export P2P_MODE="-m client"
export NAS_PORT="-P 12580"
export LOCAL_PORT="-p 10800"
export LOCAL_IP="-l 0.0.0.0"
export CENTER_HOST="-c p2palloc.tt-cool.com"
#export CENTER_HOST="-c p2palloc.nas.cyxtech.com"

export CENTER_PORT="-C 8000"
export DUMPPORT="--dump_port 5555"

p2pbin $P2P_MODE $CLIENT_UUID $NAS_UUID $NAS_PORT \
  $LOCAL_PORT $LOCAL_IP $CENTER_HOST $CENTER_PORT \
  $BROADCAST $LOG_LEVEL $RELAY_RATE $NORMAL_RATE $DUMPPORT \
  -v DEBUG
#--ltun_udp_port 44333 --adaptor_udp_port 44334
