#!/usr/bin/sh

for f in inputs/maze*
do 
	echo $f
	ruby maze.rb validate $f
done

