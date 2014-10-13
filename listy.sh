# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

function cleanup {
	rm listypid
	exit
}

trap cleanup SIGINT

echo $$ > listypid

port="30140"

while true; do
	msg=$(nc -l $port)
	echo $msg >> cmsg
done
