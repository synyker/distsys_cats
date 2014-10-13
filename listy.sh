# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

function cleanup {
	rm listypid
	exit
}

trap cleanup SIGINT

echo $$ > listypid

port=$(cat "nc_port_number")

while true; do
	msg=$(nc -l -q 0 $port)
	echo $msg >> cmsg
done