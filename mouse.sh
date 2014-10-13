# The mouse starts by going to one of the Ukko's nodes and listens a port through nc.

echo $$ > mousepid

port=$(cat "nc_port_number")
echo "$port"
echo "MOUSE: FIRST NC STARTING" >> ex2.log
res=$(nc -l -q 0 $port)

echo "MOUSE RESULT: $res"

while true; do
	
	if [ "${res:${#res} - 4}" == "MEOW" ]
	then
		name=${res:0:5}
		if [ "$name" == "Catty" ]
		then
			pid=$(cat "cattypid")
			kill -INT $pid
		elif [ "$name" == "Jazzy" ]
		then
			pid=$(cat "jazzypid")
			kill -INT $pid
		fi
		break
	else if [ "$res" == "HI MOUSE"]
		res=$(nc -l -q 0 $port)
	fi

done
