#!/user/bin/sh

for d in public*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

for d in semipublic*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

for d in release*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

for d in secret*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

