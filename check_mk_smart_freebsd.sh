#!/bin/bash
# https://github.com/zmielna/smart_diskinfo
# Backblaze chaps have 40k disks and they care about SMART 187 mainly
# see https://www.backblaze.com/blog/hard-drive-smart-stats/
# This is Check_mk local check script for FreeBSD based NAS like NAS4FREE
# Drop a copy to /usr/lib/check_mk_agent/local/
# then "telnet nas4free.domain.com 6556" from your OMD server 
for i in `ls /dev/ada?`;
        do
                ERRORS=`smartctl -a $i|egrep '^187'|awk '{print $NF}'`
                if [ $ERRORS -gt "0" ]
                        then
                        echo "2 Disk_$i Reported_Uncorrectable_Errors=$ERRORS;1;5 CRITICAL - Disk $i has $ERRORS Uncorrectable Err
ors Reported!"
                        else
                        echo "0 Disk_$i Reported_Uncorrectable_Errors=$ERRORS;1;5 OK - Disk $i has $ERRORS Uncorrectable Errors Re
ported"

                fi
        done

