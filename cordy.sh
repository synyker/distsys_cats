# Cordy starts up mouse.sh and listy.sh and gives them appropriate time to start up.
# Cordy then dispatches Catty and Jazzy so that they 
# search the possible Ukko nodes one by one. Catty and Jazzy 
# communicate to Cordy through Listy cat.

# Cordy reads the messages from the cmsg file. Cordy coordinates the search by 
# sending Catty and Jazzy with ssh to the nodes to search the mouse. 

echo "CORDY STARTED"

found=0
linecounter=1
char="p"
baseip=".hpc.cs.helsinki.fi"
folder=$(pwd)

# Start listy.sh on the correct node
listynode=$(cat "listy_location")
ssh $listynode$baseip "cd $folder && ./listy.sh" &

# Sleep to make sure listy actually is started before cats start messaging it
sleep 4

# First send the mouse to random ukko node
countnodes=$(cat ukkonodes | wc -l)
rnd=$(( ( RANDOM % $countnodes ) + 1 ))
mousenode=$(sed -n "$rnd$char" < ukkonodes)
ssh $mousenode$baseip "cd $folder && ./mouse.sh" &

# Sleep to make sure mouse actually is started before cats start looking for it
sleep 4

# Then send the cats to first two nodes in the list
node=$(sed -n "$linecounter$char" < ukkonodes)
ssh $node$baseip "cd $folder && ./chase_cat.sh S Catty" &

linecounter=$[$linecounter+1]
node=$(sed -n "$linecounter$char" < ukkonodes)
ssh $node$baseip "cd $folder && ./chase_cat.sh S Jazzy" &

echo "ALL SCRIPTS STARTED, RUNNING"

while true; do

	count=$(cat ukkonodes | wc -l)
	if [ $count -gt 0 ]
	then
		line=$(head -n 1 cmsg)
		if [ -n "$line" ]
		then
			echo "CORDY MESSAGE: $line"
			cat=${line:${#line} - 5}

			catcommand=${line:0:1}

			# Found the mouse, send the other cat to the same node
			if [ $catcommand == "F" ]
			then
				
				node=${line:2:7}
				found=$[$found+1]
				
				searchmore=1
				attack=2

				# One cat found the mouse, send the other to the same node
				if [ "$found" -eq "$searchmore" ]
				then
					if [ "$cat" == "Catty" ]
					then
						# Sleep until cat's old process dies
						while [ -e jazzypid ]; do
							sleep 1
						done
						echo "CORDY: SENDING JAZZY TO SEARCH $node"
						ssh $node$baseip "cd $folder && ./chase_cat.sh S Jazzy" &
						
					elif [ "$cat" == "Jazzy" ]
					then
						# Sleep until cat's old process dies
						while [ -e cattypid ]; do
							sleep 1
						done
						echo "CORDY: SENDING CATTY TO SEARCH $node"
						ssh $node$baseip "cd $folder && ./chase_cat.sh S Catty" &

					fi

				# Both cats found the mouse, send attack command
				elif [ "$found" -eq "$attack" ]
				then
					echo "CORDY: SENDING $cat TO ATTACK MOUSE ON $node"
					ssh $node$baseip "cd $folder && ./chase_cat.sh A $cat" &
				fi

			# No mouse at the node, send the cat to the next node
			elif [ $catcommand == "N" ]
			then
				
				linecounter=$[$linecounter+1]

				# Only proceed if end of ukkonodes file hasn't been reached
				if [ $linecounter -le $count ]
				then
					node=$(sed -n "$linecounter$char" < ukkonodes)
					echo "CORDY: $cat NO MOUSE ON $node"
					ssh $node$baseip "cd $folder && ./chase_cat.sh S $cat" &
				fi

			# The mouse was caught, cordy sends SIGINT to listy and exits
			elif [ $catcommand == "G" ]
			then
				
				echo "VICTORY TO THE CATKIND"

				exit

			fi

			# Remove the line handled by this iteration from cmsg
			sed -i 1d cmsg
		else
			# Remove a line from cmsg in case of faulty inputs, mostly empty lines
			sed -i 1d cmsg
		fi
	fi

	sleep 3

done