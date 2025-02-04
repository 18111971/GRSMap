#!/bin/bash

export LC_ALL=C

nrighe=`wc ../Input/input-acc.dat | awk '{print $1}'`
echo Numero di righe in input $nrighe
nrighe=$( echo $nrighe+1 | bc)
xorig=14.28 
yorig=40.1

counter=1 
while [ $counter -lt $nrighe ]; do
    var=$( echo $yorig+$counter*0.04 | bc)
    PGA=`sed -n $counter\p ../Input/input-acc.dat | awk '{print 100.0*$3/9.81}'`  
    PGV=`sed -n $counter\p ../Input/input-vel.dat | awk '{print 100.*$3}'`  
    staz=`sed -n $counter\p ../Input/input-acc.dat | awk '{print $4}'`
    echo  $xorig $var $staz | awk '{printf "%4.2f %4.2f 14 0 4 LT |  %4s  |  PGA= %3.1E  |  PGV= %3.1E\n",$1,$2+0.01,"'$staz'",'$PGA','$PGV'}' | sed 's/E-/x10-/g' | sed 's/E+/x10+/g' >> pippo.txt   
    echo  $xorig $var $staz $PGA $PGV
    let counter=counter+1
done
/bin/cp pippo.txt frame.txt
/bin/rm pippo.txt
#/bin/rm frame 
