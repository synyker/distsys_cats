# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

function cleanup {
	rm listypid
	exit
}

trap cleanup SIGINT

echo $$ > listypid

# Empty the cmsg file

echo "" > cmsg  
port=$(cat "nc_port_number")

#nc -l -k $port >> cmsg

while true; do
	msg=$(nc -l $port)
	echo "$msg" >> cmsg
done
