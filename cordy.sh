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

while true; do

	count=$(cat cmsg | wc -l)

	if [ $count -gt 0 ]
	then
		line=$(head -n 1 cmsg)
		sed -i 1d cmsg

		echo "$line"

	fi

	sleep 3
done