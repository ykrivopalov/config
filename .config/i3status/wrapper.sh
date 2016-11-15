#!/bin/bash

LINE_COUNT=0
read READ_OPS WRITE_OPS <<< `awk '{print $1 " " $5}' /sys/block/sda/stat`

while read LINE
do
    if [ $LINE_COUNT -lt 2 ]
    then
        # Skip the first line which contains the version header.
        # The second line contains the start of the infinite array.
        ((LINE_COUNT++))
        echo $LINE
    else
        PREFIX=
        if [ ${LINE:0:1} == , ]
        then PREFIX=,
             LINE=${LINE:1}
        fi

        # calculate RAM usage in percents
        RAM_USAGE=`awk '/MemTotal/ {memtotal=$2}; /MemAvailable/ {memavail=$2}; END { printf("%.0f", (100- (memavail / memtotal * 100))) }' /proc/meminfo`
        RAM_BLOCK="{\"full_text\" : \"RAM: $RAM_USAGE%\", \"name\" : \"ram\"}"

        # calculate read and write operations diff for period
        read NEW_READ_OPS NEW_WRITE_OPS <<< `awk '{print $1 " " $5}' /sys/block/sda/stat`
        READ_DIFF=`expr $NEW_READ_OPS - $READ_OPS`
        WRITE_DIFF=`expr $NEW_WRITE_OPS - $WRITE_OPS`
        READ_OPS=$NEW_READ_OPS
        WRITE_OPS=$NEW_WRITE_OPS
        RW_BLOCK="{\"full_text\" : \"RW: $READ_DIFF/$WRITE_DIFF\", \"name\" : \"rw_operations\"}"

        FIXED_LINE=`echo "$LINE" | jq --compact-output -M ". |= [$RW_BLOCK,$RAM_BLOCK] + ."`
        echo "$PREFIX$FIXED_LINE"
    fi
done
