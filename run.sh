#!/bin/bash

# CTRL-C kills all leaves - use file->quit to exit ztree.
trap killgroup SIGINT
killgroup(){
	kill `ps -ef | grep "zleaf" | grep -v grep | awk '{print $2}'`
}

# Check if ztree is already running, otherwise exit
if [[ -z $(ps -ef | grep "ztree" | grep -v grep) ]];
then
	# wine ztree.exe /dir datafiles /language en > /dev/null 2>&1 &
	wine ztree.exe /dir ../datafiles /language en > ../ztree.log 2>&1 &
	echo "No ztree.exe running so I'll start it for you. Run the shell script again to start the leaves. To quit ztree.exe use file->quit."
	exit;
fi

if [[ -z $1 ]];
then
	echo "Since ztree.exe is running I'll start some Leaves."
	echo "Enter the number of ZLeaf.exe's to start:"
	read leafs
	echo "Exit by pressing CTRL-C."
else
	leafs="$1"
fi

# test that $leafs is integer
if [[ "$leafs" -eq "$leafs" ]] 2> /dev/null
then
	# Kill all old leaves that are running (or nothing happens) and delete old log file
	ps -ef | grep "zleaf" | grep -v grep | awk '{print $2}' | xargs kill
	rm -f ../zleaf.log

	# Start new leaves
	for i in `seq 1 $leafs`; do
		# Windowed mode does not seem to work...
		wine explorer /desktop=$i,800x600 "zleaf.exe" /name "Client $i" /language en >> ../zleaf.log 2>&1 &
	done
	wait
else
	echo "$leafs is not an integer"
	exit
fi
