# The mouse is tarted by cordy.sh
# It is sent to one of the Ukko nodes and listens a port through nc.

echo "MOUSE STARTED"

echo $$ > mousepid

port=$(cat "nc_port_number")
res=$(nc -l -q 0 $port)

echo "MOUSE RESULT: $res"

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

	exit
fi