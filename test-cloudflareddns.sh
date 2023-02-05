#!/usr/bin/env bash

export token="123"
export zoneid="123"
export hostname="example.com"
export ipv6="$(curl -s 6.ipw.cn)"
#export ipv4=(curl -s 4.ipw.cn)
export hostIpFile="hostip"
export hostIpHisFile="hostip-history"

if [ ! -f $hostIpFile ]; then
  touch ${hostIpFile}
fi
if [ ! -f $hostIpHisFile ]; then
  touch ${hostIpHisFile}
fi

if [ "$(cat $hostIpFile)" == "${ipv6}" ]; then
  echo ">$(date) ==> Last Ip is the same as host Ip"
  exit 0;
fi

bash cloudflareddns.sh ${zoneid} ${token} ${hostname} "${ipv6}"
#cloudflareddns.sh ${zoneid} ${token} ${hostname} ${ipv4}

errCode=$?

if [ $errCode -ne 0 ]; then
  echo ">$(date) ==> Update failed"
else
  echo ">$(date) ==> Updated: ${ipv6}"
  echo "${ipv6}" > $hostIpFile
  echo "${ipv6}" >> $hostIpHisFile
fi
