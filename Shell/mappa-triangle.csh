#!/bin/bash
export LC_ALL=C
#export PATH=/opt/GMT/GMT4.0/bin/:$PATH
#export GMTHOME=/opt/GMT/GMT4.0/
export PATH=/usr/lib/gmt/bin/:$PATH
export GMTHOME=/usr/lib/gmt/

#
gmtset ANNOT_FONT_PRIMARY      = Times-Roman
gmtset LABEL_FONT_SIZE         = 12p
gmtset ANNOT_FONT_SIZE         = 12p
#
#triangulate ../Output/station.dat  -JM14.25 -V -M > net.dat
#
sed -n 20p ../Parametri/configure.txt > pippo1
sed -n 21p ../Parametri/configure.txt > pippo2
sed -n 22p ../Parametri/configure.txt > pippo3
sed -n 23p ../Parametri/configure.txt > pippo4
sed -n 37p ../Parametri/configure.txt > pippo5
sed -n 43p ../Parametri/configure.txt > pippo6
sed -n 47p ../Parametri/configure.txt > pippo7
#
paste pippo1 pippo2 pippo3 pippo4 pippo5 pippo6 pippo7 > pippo
#
Longmin1=`awk '{printf ("%3.3f",$1)}' pippo`
Longmax1=`awk '{printf ("%3.3f",$2)}' pippo`
Latmin1=`awk '{printf ("%3.3f",$3)}' pippo`
Latmax1=`awk '{printf ("%3.3f",$4)}' pippo`
#
Longmin=`awk '{printf ("%3.2f",$1)}' pippo`
Longmax=`awk '{printf ("%3.2f",$2)}' pippo`
Latmin=`awk '{printf ("%3.2f",$3)}' pippo`
Latmax=`awk '{printf ("%3.2f",$4)}' pippo`
#
dig=`awk '{print $5}' pippo`
Tens=`awk '{print $6}' pippo`
Ncont=`awk '{print $7}' pippo`
#
nc=`awk '{print $1}' ../GMT/line-contour.dat`
ncA=`awk '{print 3*$1}' ../GMT/line-contour.dat`
#
echo $nc
echo $ncA
echo $Longmin
echo $Longmax
echo $Latmin
echo $Latmax
echo $dig
echo $Tens
echo $Ncont
#
#
pscoast -Lf14.6/40.3/40.7/50 -JM14.25 -R$Longmin1/$Longmax1/$Latmin1/$Latmax1 -B0.5WSne -S119/136/153 -W5 -Di -P -Y12 -K > test.ps 
psxy ../Output/griglia-optima.dat -JM -R -B -K -V -P -Sc.15 -W3 -O >> test.ps
psxy ../Output/baricentri.dat -JM -R -B -Sc.15 -G255/0/0 -K -P -O >> test.ps
#psxy ../Output/baricentri_test.dat -JM -R -B -M -L -W5/255/0/0 -K -P -O >> test.ps
#psxy ../Output/stazioni.dat -JM -R -B -V -P -O -K -St.4 -G0 >> test.ps
#psxy circle.dat -JM -R -B -V -P -O -K -Sc.05 -G0 >> test.ps
psxy ../station.dat -JM -R -B -V -P -O -K -St.45 -G0 >> test.ps
psxy ../Output/plot_tri -JM -R -B -V -P -O -M -K -W4 >> test.ps
#psxy net.dat -JM -R -B -V -P -O -M -K -W5 >> test.ps
psxy ../Parametri/epicentro-mag.dat -JM -R -B -V -P -O -Sa.7 -W4 -G119/136/153 >> test.ps
#
ps2epsi test.ps temp.epsi
convert temp.epsi mappa-triangle.png
rm -f temp.epsi
/bin/mv mappa-triangle.png ../Mappe/ 
/bin/mv test.ps ../Mappe/mappa-triangle.ps 
gzip -f ../Mappe/mappa-triangle.ps 
/bin/rm pippo*
#gs -sDEVICE=x11 test.ps
#/bin/rm int.xyz 
#/bin/rm test.ps
#gs -sDEVICE=x11 ../Mappe/mappa-triangle.ps
#gv ../Mappe/mappa-triangle.ps
