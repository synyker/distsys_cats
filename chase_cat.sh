# Catty and Jazzy communicate to Cordy through Listy cat.

name=$2
port=$(cat "nc_port_number")

if [ $1 == "S" ]
then
	echo "SEARCHING"
	res=$(nc -v -w 0 localhost $port 2>&1)
	if [ ${res:${#res} - 10} == "succeeded!" ]
	then
		echo "success!"
	else
		echo "failure!"
	fi

elif [ $1 == "A" ]
then

	curhost=$(hostname)
	res=$(echo "MEOW" | nc localhost $port)
fi
