#!/bin/bash -x

# For some reason removing stuff from Dropbox on the windows mount causes intermittent failures.
# So just retry a few times.
max_retry=5
counter=0
until rm -rf /mnt/c/Users/dbese/Dropbox/pico8/root/mine
do
    sleep 0.1
    [[ counter -eq $max_retry ]] && echo "Failed!" && exit 1
    echo "Trying again. Try #$counter"
    ((counter++))
done

cp -r mine /mnt/c/Users/dbese/Dropbox/pico8/root/
