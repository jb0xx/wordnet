for f in *.txt
do 
        d=${f%.*}
 
        mv $f $d
done

