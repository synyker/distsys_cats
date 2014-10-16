i=1
length=10 #$(cat ukkonodes|wc -l)
char="p"
baseip=".hpc.cs.helsinki.fi"

while [ $i -le $length ]; do
	node=$(sed -n "$i$char" < ukkonodes)
	ssh $node$baseip "killall -u jonnaira"
	i=$[$i+1]
done

ssh ukko181$baseip "killall -u jonnaira"
