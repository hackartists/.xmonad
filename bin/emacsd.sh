#! /bin/bash
count=`netstat -p | grep emacs | wc -l`
while [ $count -ne 2 ]; do
    sleep 1
    count=`netstat -p | grep emacs | wc -l`
done

echo "Running Emacs"
