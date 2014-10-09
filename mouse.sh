# The mouse starts by going to one of the Ukko's nodes and listens a port through nc.

pid=$$
echo "pid: $pid"

port=$(cat "nc_port_number")
echo "$port"

var=`nc -l -q 0 $port`

while true; do

    if [ "$var" == "MEOW" ]
    then
        
    else
        var=`nc -l -q 0 $port`
    fi
done
