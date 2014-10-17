# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

function cleanup {
	rm listypid
	exit
}

echo "LISTY STARTED"

trap cleanup SIGINT

echo $$ > listypid

# Empty the cmsg file
echo "" > cmsg  
port=$(cat "nc_port_number")

while true; do
	msg=$(nc -l $port)
	echo "$msg" >> cmsg

	if [ "${msg:0:1}" == "G" ]
	then
		echo "LISTY: SHUTTING DOWN"
		exit
	fi
done
