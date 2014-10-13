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
		name=${res:0:1}
		if [ "$name" == "C" ]
		then
			pid=$(cat "cattypid")
			kill -INT $pid
		elif [ "$name" == "J" ]
		then
			pid=$(cat "jazzypid")
			kill -INT $pid
		fi
		break
	else if [ "$res" == "HI MOUSE"]
		res=$(nc -l -q 0 $port)
	fi

done
