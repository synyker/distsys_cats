# Catty and Jazzy communicate to Cordy through Listy cat.

port=$(cat "nc_port_number")
curhost=$(hostname)
listy=$(cat "listy_location")

trap "echo 'G $curhost $2' | nc $listy $port" SIGINT

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
		echo "F $curhost $2" | nc $listy $port

	# If not, send the N message to listy.sh
	else		
		echo "N $curhost $2" | nc $listy $port
	fi

elif [ $1 == "A" ]
then
	res=$(echo "$2: MEOW" | nc localhost $port)
	sleep 10s
	echo "SHUTTING DOWN..."
	break
else
	break
fi
