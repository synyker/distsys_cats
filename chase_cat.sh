# Catty and Jazzy communicate to Cordy through Listy cat.

port=$(cat "nc_port_number")
curhost=$(hostname)
name=$2
listyip=$(cat "listy_location")

function message_listy {
	echo "messaging listy"
	echo "G $curhost $name"  | nc $listyip 28438 #$port

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
	
	echo "chase_cat: SEARCHING" >> ex2.log

	# Try to connect to the mouse.sh netcat on current ukko node
	res=$(nc -v -w 0 localhost $port 2>&1)

	# If the connection is succesful, send the F message to listy.sh
	if [ "${res:${#res} - 10}" == "succeeded!" ]
	then
		echo "F $curhost $name" | nc $listyip $port

	# If not, send the N message to listy.sh
	else		
		echo "N $curhost $name" | nc $listyip $port
	fi

# If attacking
elif [ $1 == "A" ]
then
	# The attack takes 5 seconds
	sleep 5
	# The attacking cat's name is attached to the message for the mouse to distinguish between attackers
	res=$(echo "$name: MEOW" | nc localhost $port)
	# The attacking cat will wait 10 seconds for the SIGINT signal, then exit if it's not received
	sleep 10
	exit
else
	exit
fi
