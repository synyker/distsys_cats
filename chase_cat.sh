# Catty and Jazzy communicate to Cordy through Listy cat.

name=$2
port=$(cat $file"/nc_port_number")

if [ $1 == "S" ]
then
	echo "SEARCHING"
	res=$(netcat -v -w 0 localhost $port)
	if [ ${res:-10} == "succeeded!" ]
	then
		echo "success!"
	fi

elif [ $1 == 'A' ]
then
	
	
	

	curhost=$(hostname)
fi