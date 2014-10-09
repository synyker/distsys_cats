# Catty and Jazzy communicate to Cordy through Listy cat.

command=$1
name=$2
port=$(cat $file"/nc_port_number")

if [ $command == "S" ]
then
	echo "SEARCHING"
	res=$(netcat -v -w 0 localhost $port)
	if [ ${res:-10} == "succeeded!" ]
	then
		echo "success!"
	fi

elif [ $command == 'A' ]
then
	
	
	

	curhost=$(hostname)
fi