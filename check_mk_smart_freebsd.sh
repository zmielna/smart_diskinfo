#!/bin/bash
# https://github.com/zmielna/smart_diskinfo
# Backblaze chaps have 40k disks and they care about SMART 187 mainly
# see https://www.backblaze.com/blog/hard-drive-smart-stats/
# This is Check_mk local check script for FreeBSD based NAS like NAS4FREE
# Drop a copy to /usr/lib/check_mk_agent/local/
# you can "telnet nas4free.domain.com 6556" from your OMD server to see if it works.
#
#    SMART 5 \u2013 Reallocated_Sector_Count.
#    SMART 187 \u2013 Reported_Uncorrectable_Errors.
#    SMART 188 \u2013 Command_Timeout.
#    SMART 197 \u2013 Current_Pending_Sector_Count.
#    SMART 198 \u2013 Offline_Uncorrectable.
# So we care mostly about 187 but if your disk doesn't return this value use 198 or other
#
# For linux change /dev/ada? to /dev/sd?

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

