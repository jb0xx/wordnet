#!/usr/bin/sh

for f in maze1 maze2 maze3
do 
	cp tests/t tests/public_closed_$f.rb
	cp tests/t tests/public_distance_$f.rb
	cp tests/t tests/public_open_$f.rb
	cp tests/t tests/public_paths_$f.rb
	cp tests/t tests/public_print_$f.rb
	cp tests/t tests/public_solve_$f.rb
done
for f in maze1-std maze2-std maze3-std maze4-std
do 
	cp tests/t tests/public_parse_$f.rb
done

for f in maze4 maze5
do 
	cp tests/t tests/semipublic_closed_$f.rb
	cp tests/t tests/semipublic_distance_$f.rb
	cp tests/t tests/semipublic_open_$f.rb
	cp tests/t tests/semipublic_paths_$f.rb
	cp tests/t tests/semipublic_print_$f.rb
	cp tests/t tests/semipublic_solve_$f.rb
done
for f in maze4b-std maze5-std
do 
	cp tests/t tests/semipublic_parse_$f.rb
done

for f in maze10 maze15 maze18 maze19 maze20 maze21 maze22 maze23 maze24 maze25 maze26 maze27 maze28 maze29 
do 
	cp tests/t tests/release_closed_$f.rb
	cp tests/t tests/release_distance_$f.rb
	cp tests/t tests/release_open_$f.rb
	cp tests/t tests/release_paths_$f.rb
	cp tests/t tests/release_print_$f.rb
	cp tests/t tests/release_solve_$f.rb
done
for f in maze6-std maze7-std maze8-std maze9-std
do 
	cp tests/t tests/release_parse_$f.rb
done

for f in maze30 maze31 maze40 maze41 maze42 maze43 maze44 maze45 maze46 maze47 maze50
do 
	cp tests/t tests/secret_closed_$f.rb
	cp tests/t tests/secret_distance_$f.rb
	cp tests/t tests/secret_open_$f.rb
	cp tests/t tests/secret_paths_$f.rb
	cp tests/t tests/secret_print_$f.rb
	cp tests/t tests/secret_solve_$f.rb
done
for f in maze10-std maze11-std maze15-std maze18-std maze19-std
do 
	cp tests/t tests/secret_parse_$f.rb
done


