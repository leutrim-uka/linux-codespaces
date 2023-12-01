#!/usr/bin/env bash

echo "How many lines do you want?"
read LINES

declare -a array=("apple" "pear" "cherry")

COUNT=1
while [ $COUNT -le $LINES ]
do
    rand=$[ $RANDOM % 3 ]
    echo "$COUNT ${array[$rand]}" >> ../files/filter-file.txt
    ((COUNT++))
done