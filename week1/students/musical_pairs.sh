#!/bin/bash
#

# get date
# parse date in a way where it is just numbers
# don't select same team member (need to figure out combinations)
#


cd students

name=($(ls | cut -d' ' -f1 | awk -F. '{print $1}'))

day=$(date +%d)

combination=$((day % 11))

if (( $combination > 6 )); then
    iterations=$((combination - 6))
    for ((i=0; i < iterations; i++)); do
        reserve=${name[1]}
        for ((j=1; j<12; j+=2)); do
            if (( j+2 < 12 )); then
                name[j]=${name[$((j+2))]}
            else
                name[j]=${name[$(((j+2) % 12))]}
            fi
        done
        name[11]=$reserve
    done
else
    for ((i=0; i < combination; i++)); do
        temp=${name[1]}
        for ((j=2; j<12; j+=2)); do
            if (( j == 2)); then
                name[j-1]=${name[j]}
            else
                name[j-2]=${name[j]}
            fi
        done
        name[10]=$temp
    done
fi

for ((i=0; i < 12; i++)); do
    if (( i % 2 == 0)); then
        echo "--------------"
    fi
    echo ${name[i]}
done


#!/bin/bash

# check for the md5sum command
# if installed with coreutils, will have "g" in front of it
if [ `which md5sum` ]
then
    md5_cmd=md5sum
elif [ `which gmd5sum` ]
then
    md5_cmd=gmd5sum
else
    echo "Please install md5sum"
    exit 1
fi

# check for the shuf command
# if installed with coreutils, will have "g" in front of it
if [ `which shuf` ]
then
    shuf_cmd=shuf
elif [ `which gshuf` ]
then
    shuf_cmd=gshuf
else
    echo "Please install shuf"
    exit 1
fi

# use the date to set a random seed for the shuf command
# note: apparently shuf uses the initial bytes of the file
# so hash the date to get a random first character in the file
date +"%Y%m%d" | $md5_cmd > /tmp/ymd; ls *.txt | $shuf_cmd --random-source=/tmp/ymd | awk '{print; if (NR % 2 == 0) print "--------"}' | sed 's/\.txt$//'
