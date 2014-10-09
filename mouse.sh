# The mouse starts by going to one of the Ukko's nodes and listens a port through nc.

pid=$$
echo "$pid"
echo "$rnd"
end=${pid:${#pid} - 3}
port="30$end"

file=`pwd`
port=$(cat $file"/nc_port_number")

echo "$port"
var=`nc -l -q 0 $port`

rnd=$(( ( RANDOM % 100 ) + 1 ))

while true; do

    if [ "$var" == "MEOW" ]
    then
        if [ "$rnd" -lt 76 ]
        then
            echo "$rnd: RUNNING AWAY"
            var=`nc -l -q 0 $port`
            rnd=$(( ( RANDOM % 100 ) + 1 ))

        else
            echo "$rnd: I WAS CAUGHT"
            break
        fi
    else
        var=`nc -l -q 0 $port`
    fi
done
