# Distributed Systems fall '14: Bash Script Excercise

## Instructions
To run the scripts, simply start cordy.sh. Cordy will then start up listy.sh on its' specified node, mouse.sh on a random node from the list of nodes and two instances of chase_cat.sh on the two first nodes in the ukkonodes file. 

The scripts can be run on any linux server with a shared filesystem with the ukko nodes.

## Execution process
Since the execution process of the chase_cat.sh, listy.sh and mouse.sh are really simple, I will not detail them here. The actual script files are simple, well commented and implemented according to the instructions.

As mentioned in the previous section, Cordy starts up the other scripts. After all the scripts are running, Cordy starts a loop in which it reads the first line of the cmsg file and acts according to what happens to be on the first line.

Firt, Cordy checks if the line is an empty line. If it is, the line is removed and the loop proceeds to the next iteration. If not, the first character of the line (hopefully F, N or G) is saved into a variable.

If the first character is F, a mouse was found on the node specified by the rest of the line. If this is the first found message received by cordy, it checks which cat sent this message and sends the other cat to the same node as well. Because of the restriction of only one instance per cat allowed, Cordy doesn't send a cat to search a node before its' pidfile is gone. If this was the second cat to find a mouse on that node, the cat that sent the message is sent to attack the mouse.

If the first character is N, no mouse was found on the node specified by the rest of the line. The cat sending this message is then sent to the next node in the ukkonodes file. The linecounter variable keeps track of the next node.

If the first character is G, the mouse was successfully attacked by one of the cats, and the cats are victorious. Cordy exits and the other scripts have already exited.

## Additional information
The processes save pidfiles with their specific names (cattypid, jazzypid, listypid) to the folder, which can be used for checking whether the processes are up and running and grabbing the pid if needed. For example, the mouse gets the attacking cats name with the MEOW-message, then finds out its' pid from the cat's pid file and sends the SIGINT signal to it.

The cats don't check the ukko node for a running process of mouse.sh, instead, they check for an open port using the lsof -i command.

The scripts include some echo commands that have information of the execution progress. At first, I figured I would remove them before returning the assignment, but I decided to leave them in, since it gives a clear view of the execution process.

Some additional sleep commands had to be added to the scripts, because the startup time of the scripts was unpredictable. Mostly this meant that the chase_cat.sh processes might already be started up, while neither the mouse.sh or listy.sh were running. In this case, the mouse wasn't there yet, so it couldn't be detected by the chase_cat.sh and also the cats couldn't message listy.sh because it wasn't listening yet.


## Troubleshooting

In case some of the scripts die during execution and for example leave netcat running on a node, I've included a script called kill_processes.sh, which kills all of the current users processes on the used ukkonodes and on the node listy.sh uses.

This is just a precaution, there shouldn't be any bugs in the code allowing this to happen anymore, this was mostly a tool for the development phase of this exercise.
