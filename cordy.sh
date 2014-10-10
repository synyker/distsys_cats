# Then it is up to Cordy to dispatch Catty and Jazzy so that they 
# search the possible Ukko nodes one by one. Catty and Jazzy 
# communicate to Cordy through Listy cat.

# Cordy reads the messages from the cmsg file. Cordy coordinates the search by 
# sending Catty and Jazzy with ssh to the nodes to search the mouse. 
# Cordy gives the commands as command line parameter as follows:

# S catname   Search the node (e.g. ./chase_cat.sh S Jazzy)
# A catname   Attack the mouse on the node

# Catty and Jazzy can send the following messages to Listy using nc:

# F ukkoXXX catname     Found the mouse on ukkoXXX (e.g. F ukko300 Catty),
# N ukkoXXX catname    No mouse on ukkoXXX,
# G ukkoXXX catname    Got the mouse

found=0
linecounter=1
char="p"
baseip=".hpc.cs.helsinki.fi"
folder=$(pwd)

# First send the mouse to random ukko node
countnodes=$(cat $folder/ukkonodes | wc -l)
rnd=$(( ( RANDOM % $countnodes ) + 1 ))
mousenode=$(sed -n "$rnd$char" < $folder/ukkonodes)
ssh $mousenode$baseip .$folder/mouse.sh

# Start listy.sh on the correct node
listynode=$(cat "$folder/listy_location")
ssh $listynode$baseip .$folder/listy.sh

# Then send the cats to first two nodes in the list
node=$(sed -n "$linecounter$char" < $folder/ukkonodes)
echo $node
ssh $node$baseip .$folder/chase_cat S Catty

linecounter=$[$linecounter+1]
node=$(sed -n "$linecounter$char" < $folder/ukkonodes)
echo $node
ssh $node$baseip .$folder/chase_cat S Jazzy

while true; do

	count=$(cat $folder/cmsg | wc -l)

	if [ $count -gt 0 ]
	then
		line=$(head -n 1 $folder/cmsg)
		cat=${line:${#line} - 5}

		# Found the mouse, send the other cat to the same node
		if [ ${line:0:1} == "F"]
		then
			
			node=${line:2:7}
			found=$[$found+1]

			# One cat found the mouse, send the other to the same node
			if [ $found -eq 1 ]
			then
				if [ $cat == "Catty" ]
				then
					# Sleep until cat's old process dies
					while [ -e $folder/jazzypid ]; do
						sleep 1
					done
					
					ssh $node$baseip .$folder/chase_cat S Jazzy
					
				elif [ $cat == "Jazzy" ]
				then
					# Sleep until cat's old process dies
					while [ -e $folder/cattypid ]; do
						sleep 1
					done
	
					ssh $node$baseip .$folder/chase_cat S Catty

				fi

			# Both cats found the mouse, send attack command
			elif [ $found -eq 2 ]
			then
				ssh $node$baseip .$folder/chase_cat A $cat
			fi
			
			echo "$node"

		# No mouse at the node, send the cat to the next node
		elif [ ${line:0:1} == "N"]
		then
			
			linecounter=$[$linecounter+1]

			# Only proceed if end of ukkonodes file hasn't been reached
			if [ $linecounter -le $count ]
			then
				node=$(sed -n "$linecounter$char" < ukkonodes)
				ssh $node$baseip .$folder/chase_cat S $cat
			fi

		# The mouse was caught, cordy sends SIGINT to listy and exits
		elif [ ${line:0:1} == "G"]
		then
			
			echo "VICTORY"
			pid=$(cat "$folder/listypid")
			kill -INT $pid
			exit

		fi

		sed -i 1d $folder/cmsg

	fi

	sleep 3
done