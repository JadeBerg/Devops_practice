#!/bin/bash

file_out=out

#1
echo "From which ip were the most requests?"
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" $1 | sort | uniq -c | sort -gr > $file_out
head -n 1 $file_out | tail -n 1

#3
echo "How many requests were there from each ip?"
cat $file_out

#2
echo "What is the most requested page?"
awk '{print $7}' $1 | sort | uniq -c | sort -gr > $file_out
head -n 1 $file_out | tail -n 1

#4
echo "What non-existent pages were clients referred to?"
grep "/error404" $1 > $file_out
cat $file_out

#5
echo "What time did site get the most requests?"
grep "/sitemap1.xm" $1 > $file_out
tail -n1 $file_out | awk '{print $4}'

#6
echo "What search bots have accessed the site? (UA + IP)"
awk '{print $1,$14,$15,$16,$17}' $file_out
