# Then it is up to Cordy to dispatch Catty and Jazzy so that they 
# search the possible Ukko nodes one by one. Catty and Jazzy 
# communicate to Cordy through Listy cat.

# Cordy reads the messages from the cmsg file. Cordy coordinates the search by 
# sending Catty and Jazzy with ssh to the nodes to search the mouse. 
# Cordy gives the commands as command line parameter as follows:

# S catname   Search the node (e.g. ./chase_cat.sh.sh S Jazzy)
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
echo "$folder"

sleep 3

# First send the mouse to random ukko node
countnodes=$(cat ukkonodes | wc -l)
rnd=$(( ( RANDOM % $countnodes ) + 1 ))
mousenode=ukko192 #$(sed -n "$rnd$char" < ukkonodes)
ssh $mousenode$baseip "cd $folder && ./mouse.sh" &

# Start listy.sh on the correct node
listynode=$(cat "listy_location")
ssh $listynode$baseip "cd $folder && ./listy.sh" &

# Then send the cats to first two nodes in the list
node=$(sed -n "$linecounter$char" < ukkonodes)
echo $node
ssh $node$baseip "cd $folder && ./chase_cat.sh S Catty" &

linecounter=$[$linecounter+1]
node=$(sed -n "$linecounter$char" < ukkonodes)
echo $node
ssh $node$baseip "cd $folder && ./chase_cat.sh S Jazzy" &

echo "SCRIPTS STARTED"

while true; do

	echo "CORDY: STARTING LOOP" >> ex2.log

	count=$(cat cmsg | wc -l)

	if [ $count -gt 0 ]
	then
		line=$(head -n 1 cmsg)
		if [ -n $line ]
		then
			cat=${line:${#line} - 5}

			# Found the mouse, send the other cat to the same node
			if [ ${line:0:1} == "F" ]
			then
				
				node=${line:2:7}
				found=$[$found+1]

				# One cat found the mouse, send the other to the same node
				if [ $found -eq 1 ]
				then
					if [ $cat == "Catty" ]
					then
						# Sleep until cat's old process dies
						while [ -e jazzypid ]; do
							sleep 1
						done
						
						ssh $node$baseip "cd $folder && ./chase_cat.sh S Jazzy" &
						
					elif [ $cat == "Jazzy" ]
					then
						# Sleep until cat's old process dies
						while [ -e cattypid ]; do
							sleep 1
						done
		
						ssh $node$baseip "cd $folder && ./chase_cat.sh S Catty" &

					fi

				# Both cats found the mouse, send attack command
				elif [ $found -eq 2 ]
				then
					ssh $node$baseip "cd $folder && ./chase_cat.sh A $cat" &
				fi
				
				echo "$node"

			# No mouse at the node, send the cat to the next node
			elif [ ${line:0:1} == "N" ]
			then
				
				linecounter=$[$linecounter+1]

				# Only proceed if end of ukkonodes file hasn't been reached
				if [ $linecounter -le $count ]
				then
					node=$(sed -n "$linecounter$char" < ukkonodes)
					ssh "$node$baseip cd $folder && ./chase_cat.sh S $cat" &
				fi

			# The mouse was caught, cordy sends SIGINT to listy and exits
			elif [ ${line:0:1} == "G" ]
			then
				
				echo "VICTORY"
				pid=$(cat "listypid")
				kill -INT $pid
				exit

			fi

			sed -i 1d cmsg
		fi
	fi

	echo "CORDY: ENDING LOOP" >> ex2.log
	sleep 3
done