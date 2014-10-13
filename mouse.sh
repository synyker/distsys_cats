# The mouse starts by going to one of the Ukko's nodes and listens a port through nc.

pid=$$
echo "pid: $pid"

port=$(cat "nc_port_number")
echo "$port"

res=`nc -v -l -q 0 $port`

sleep 10
while true; do

	if [ ${res:${#res} - 4} == "MEOW" ]
	then
		echo "I WAS CAUGHT"
		name=${res:0:5}
		echo "$name"
		if [ $name == "Catty" ]
		then
			pid=$(cat "cattypid")
			kill -INT $pid
		elif [ $name == "Jazzy" ]
		then
			pid=$(cat "jazzypid")
			kill -INT $pid
		fi
		break
	else
		res=`nc -v -l -q 0 $port`
	fi
done
