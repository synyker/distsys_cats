# Distributed Systems fall '14: Bash Script Excercise

To run the scripts, just start cordy.sh. Cordy will then start up listy.sh on its' specified node, mouse.sh on a random node from the list of nodes and two instances of chase_cat.sh on the two first nodes in the ukkonodes file. 

The processes save pidfiles with their specific names (cattypid, jazzypid, listypid) to the folder, which can be used for checking whether the processes are up and running and grabbing the pid if needed. For example, the mouse gets the attacking cats name with the MEOW-message, then finds out its' pid from the cat's pid file and sends the SIGINT signal to it.

Some additional sleep commands had to be added to the scripts, because the startup time of the scripts was unpredictable. Mostly this meant that the chase_cat.sh processes might already be started up, while neither the mouse.sh or listy.sh were running. In this case, the mouse wasn't there yet, so it couldn't be detected by the chase_cat.sh and also the cats couldn't message listy.sh because it wasn't listening yet.


## Troubleshooting

In case some of the scripts die during execution and for example leave netcat running on a node, I've included a script called kill_processes.sh, which kills all of the current users processes on the used ukkonodes and on the node listy.sh uses.
