#/bin/bash
declare -a SMART_COMMAND

# https://www.backblaze.com/blog/hard-drive-smart-stats/
# Number 187 reports the number of reads that could not be corrected using hardware ECC.
# Drives with 0 uncorrectable errors hardly ever fail. This is one of the SMART stats we usei
# to determine hard drive failure; once SMART 187 goes above 0, we schedule the drive for replacement.

echo "Checking Disks For Important Smart Errors..."
for I in $(ls /sys/block/|grep sd); do
  SMART_COMMAND="smartctl -a /dev/$I"
  SERIAL="$(smartctl -a /dev/$I | grep -i serial)"
  echo "DISK $I - $SERIAL"
  $SMART_COMMAND |egrep '^  5|^187|^188|^197|^198'
  echo "----------------"
done
