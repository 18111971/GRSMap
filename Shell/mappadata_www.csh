#!/bin/bash

export LC_ALL=C
#export PATH=/opt/GMT/GMT4.0/bin/:$PATH
#export GMTHOME=/opt/GMT/GMT4.0/
export PATH=/usr/lib/gmt/bin/:$PATH
export GMTHOME=/usr/lib/gmt/

sed -n 20p ../Parametri/configure.txt > pippo1
sed -n 21p ../Parametri/configure.txt > pippo2
sed -n 22p ../Parametri/configure.txt > pippo3
sed -n 23p ../Parametri/configure.txt > pippo4
sed -n 37p ../Parametri/configure.txt > pippo5
sed -n 43p ../Parametri/configure.txt > pippo6
sed -n 47p ../Parametri/configure.txt > pippo7

paste pippo1 pippo2 pippo3 pippo4 pippo5 pippo6 pippo7 > pippo

Longmin1=`awk '{printf ("%3.3f",$1)}' pippo`
Longmax1=`awk '{printf ("%3.3f",$2)}' pippo`
Latmin1=`awk '{printf ("%3.3f",$3)}' pippo`
Latmax1=`awk '{printf ("%3.3f",$4)}' pippo`

Longmin=`awk '{printf ("%3.2f",$1)}' pippo`
Longmax=`awk '{printf ("%3.2f",$2)}' pippo`
Latmin=`awk '{printf ("%3.2f",$3)}' pippo`
Latmax=`awk '{printf ("%3.2f",$4)}' pippo`

scx=`awk '{if( $1 lt 0.0) print $1+1.4 }' pippo`
scy=`awk '{if( $3 lt 0.0) print $3+0.1 }' pippo`

dig=`awk '{print $5}' pippo`
Tens=`awk '{print $6}' pippo`
Ncont=`awk '{print $7}' pippo`

nc=`awk '{print $1}' ../GMT/line-contour.dat`
nca=`awk '{printf("%4.2f\n", $1) }' ../GMT/line-contour.dat`
#
echo '############################'
echo $nc
echo $nca
echo $Longmin
echo $Longmax 
echo $Latmin
echo $Latmax 
echo $dig
echo $Tens 
echo $Ncont  
echo '############################'
#
pscoast -JM14.25 -R$Longmin/$Longmax/$Latmin/$Latmax -S255/255/255 -G125 -Di -Y8 -X3 -K -P > test.ps 
awk '{print $1-0.01,$2,90.0,100.*$3}' ../Input/input-acc.dat | psxy -R -JM -W2/125 -G0/215/0 -Sv0.5c/0.0c/0.1c -O -K -V -P >> test.ps
awk '{print $1+0.03,$2,90.0,1000.*$3}' ../Input/input-vel.dat | psxy -R -JM -O -W2/125 -G255/255/0 -Sv0.5c/0.0c/0.1c -K -V >> test.ps
#
psxy -JM -R -V -O -Ss0.3 -W2/125 -G0/255/0 -K <<END>> test.ps
14.65 40.45
END
psxy -JM -R -V -O -Ss0.3 -W2/125 -G255/255/0 -K <<END>> test.ps
14.65 40.40
END
#psxy -JM -R -V -O -Sa0.5 -W5 -G255/0/0 -K <<END>> test.ps
#14.75 40.30
#END
pstext -JM -R -V -O -G0 <<END>> test.ps
14.69 40.47 8 0 4 LT PGA (%g)
14.69 40.42 8 0 4 LT PGV (cm/s)
END
#14.79 40.32 14 0 4 LT Epicenter
#END
#
bboxx -insert test.ps
bboxx -insert test.ps
sed -i 's/%%HiResBoundingBox:.*//' test.ps
convert -channel alpha -fx u-0.5 +antialias -transparent white -density 600 test.ps PGOBS_trans.png
#convert +antialias -density 600 -transparent white test.ps PGOBS_trans.png
/bin/mv PGOBS_trans.png ../Mappe/.
/bin/cp test.ps ../Mappe/PGOBS_trans.ps
rm -f *.grd
rm -f *~
rm -f pippo*
#
