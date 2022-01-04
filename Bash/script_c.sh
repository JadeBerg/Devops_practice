#!/bin/bash

d_1=$(ls $1 | wc -l)
log=log_1
if [ -e "$2"/"$1" ];
then
        d_2=$(ls $2/$1 | wc -l)
        if [[ $d_1 -eq $d_2 ]]
        then
                echo "No changes!"
                exit
        else
                echo "$1 have $d_1 files and $2 have $d_2 files!" > $log
        fi
else
        echo "Go copy!"
        if [ $# -eq 0 ]
        then
                echo "Give me two arguments!"
        elif [ $# -eq 1 ]
        then
                echo "Give me second argument!"
        else
                rsync --archive --verbose --progress $1 $2
        fi
fi
