# Catty and Jazzy communicate to Cordy through Listy cat.

echo "CHASE_CAT $2 STARTED"

port=$(cat "nc_port_number")
curhost=$(hostname)
name=$2
listyip=$(cat "listy_location")
baseip=".hpc.cs.helsinki.fi"

function message_listy {
	echo "CHASE_CAT $name GOT THE MOUSE"
	echo "G $curhost $name" | nc $listyip$baseip $port

	if [ $name == "Catty" ]
	then 
		rm cattypid
	elif [ $name == "Jazzy" ]
	then
		rm jazzypid
	fi

	exit
}

trap message_listy SIGINT

# Check the parameters for the cat's name and save 
# the process pid to the cat's pid file
if [ $name == "Catty" ]
then
	echo $$ > cattypid
elif [ $name == "Jazzy" ]
then
	echo $$ > jazzypid
# Or exit if invalid cat name provided
else
	exit
fi

# If searching
if [ $1 == "S" ]
then

	# Try to connect to the mouse.sh netcat on current ukko node
	#res=$(echo "HI MOUSE" | nc -v localhost $port)
	res=$(lsof -i :$port)

	# If the connection is succesful, send the F message to listy.sh
	#if [ "${res:${#res} - 10}" == "succeeded!" ]
	if [ -n "$res" ]
	then
		echo "CHASE_CAT $2 MOUSE FOUND ON $curhost"
		echo "F $curhost $name" | nc $listyip$baseip $port

	# If not, send the N message to listy.sh
	else
		echo "CHASE_CAT $2 NO MOUSE ON $curhost"
		echo "$listyip$baseip $port"
		echo "N $curhost $name" | nc $listyip$baseip $port
	fi

# If attacking
elif [ $1 == "A" ]
then
	# The attack takes 5 seconds
	sleep 5
	# The attacking cat's name is attached to the message for the mouse to distinguish between attackers
	echo "CHASE_CAT $2 ATTACKING MOUSE ON $curhost"
	res=$(echo "$name: MEOW" | nc localhost $port)
	# The attacking cat will wait 10 seconds for the SIGINT signal, then exit if it's not received
	sleep 10
	exit
else
	exit
fi
