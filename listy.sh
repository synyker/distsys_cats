# Listy keeps an open socket through nc and writes the messages to a file called cmsg.

port=$(cat "nc_port_number")
nc -l -p $port > cmsg