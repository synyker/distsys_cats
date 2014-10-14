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

echo "CORDY STARTED"

found=0
linecounter=1
char="p"
baseip=".hpc.cs.helsinki.fi"
folder=$(pwd)

# First send the mouse to random ukko node
countnodes=$(cat ukkonodes | wc -l)
rnd=$(( ( RANDOM % $countnodes ) + 1 ))
mousenode=ukko190 #$(sed -n "$rnd$char" < ukkonodes)
ssh $mousenode$baseip "cd $folder && ./mouse.sh" &

