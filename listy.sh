# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

port=$(sed -n 2p < listy_location)
while true; do
	msg=$(nc -l $port)
	echo $msg >> cmsg
done
