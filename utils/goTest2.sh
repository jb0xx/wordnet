#!/usr/bin/sh

for d in tests/public*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

for d in tests/semipublic*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

for d in tests/release*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

for d in tests/secret*.rb
do 
	echo "-----------"
	echo $d
	echo "-----------"
        ruby $d
done

