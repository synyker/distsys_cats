# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

port=$(sed -n 2p < listy_location)
nc -l $port > cmsg
