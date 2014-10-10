# Catty and Jazzy communicate to Cordy through Listy cat.

port=$(cat "nc_port_number")
curhost=$(hostname)
name=$2
listyip=$(sed -n "1p" < "listy_location")
listyport=$(sed -n "2p" < "listy_location")

function message_listy {
	echo "messaging listy"
	echo "G $curhost $name"  | nc $listyip $listyport

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
if [ $2 == "Catty" ]
then
	echo $$ > cattypid
elif [ $2 == "Jazzy" ]
then
	echo $$ > jazzypid
else
	break
fi

# If searching
if [ $1 == "S" ]
then

	# Try to connect to the mouse.sh netcat on current ukko node
	res=$(nc -v -w 0 localhost $port 2>&1)

	# If the connection is succesful, send the F message to listy.sh
	if [ ${res:${#res} - 10} == "succeeded!" ]
	then
		echo "F $curhost $name" | nc $listyip $listyport

	# If not, send the N message to listy.sh
	else		
		echo "N $curhost $name" | nc $listyip $listyport
	fi

elif [ $1 == "A" ]
then
	res=$(echo "$name: MEOW" | nc localhost $port)
	sleep 2s
	echo "SHUTTING DOWN..."
	exit
else
	exit
fi
