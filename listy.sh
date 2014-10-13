# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

function cleanup {
	rm listypid
	exit
}

trap cleanup SIGINT

echo $$ > listypid

port="28438"

while true; do
	msg=$(nc -l -q 0 $port)
	echo "LISTY: SAVING MESSAGE" >> ex2.log
	echo $msg >> cmsg
done
