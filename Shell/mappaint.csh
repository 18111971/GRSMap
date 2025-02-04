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

Longmin=`awk '{printf ("%3.3f",$1)}' pippo`
Longmax=`awk '{printf ("%3.3f",$2)}' pippo`
Latmin=`awk '{printf ("%3.3f",$3)}' pippo`
Latmax=`awk '{printf ("%3.3f",$4)}' pippo`

scx=`awk '{if( $1 lt 0.0) print $1+0.4 }' pippo`
scy=`awk '{if( $3 lt 0.0) print $3+0.05 }' pippo`

Longmin2=`awk '{printf ("%3.3f",$1)}' ../Output/griglia-buf.dat`
Longmax2=`awk '{printf ("%3.3f",$2)}' ../Output/griglia-buf.dat`
Latmin2=`awk '{printf ("%3.3f",$3)}' ../Output/griglia-buf.dat`
Latmax2=`awk '{printf ("%3.3f",$4)}' ../Output/griglia-buf.dat`

Longmin3=`awk '{printf ("%3.2f",$1)}' ../Output/griglia-buf.dat`
Longmax3=`awk '{printf ("%3.2f",$2)}' ../Output/griglia-buf.dat`
Latmin3=`awk '{printf ("%3.2f",$3)}' ../Output/griglia-buf.dat`
Latmax3=`awk '{printf ("%3.2f",$4)}' ../Output/griglia-buf.dat`


dig=`awk '{print $5}' pippo`
Tens=`awk '{print $6}' pippo`
Ncont=`awk '{print $7}' pippo`

nc=`awk '{print $1}' ../GMT/line-contour.dat`
ncA=`awk '{print 2*$1}' ../GMT/line-contour.dat`

echo '------------'
echo $nc
echo $ncA
echo '------------'
echo $Longmin
echo $Longmax
echo $Latmin
echo $Latmax
echo '------------'
echo $Longmin1
echo $Longmax1
echo $Latmin1
echo $Latmax1
echo '------------'
echo $dig
echo $Tens
echo $Ncont
echo '------------'
#
gmtset ANNOT_FONT_PRIMARY      = Times-Roman
gmtset LABEL_FONT_SIZE         = 12p
gmtset ANNOT_FONT_SIZE         = 12p
#
#0014.11/16.73/39.98/41.72
#topotot.grd: x_min: 13.8333 x_max: 14.8333 x_inc: 0.000277778 units: user_x_unit nx: 3600
#topotot.grd: y_min: 40.5 y_max: 41 y_inc: 0.000277778 units: user_y_unit ny: 1800


#
#xyz2grd topotot.ascii -Girpinia.grd -I0.000277778 -R13.8333/14.8333/40.5/41 -V
#grdsample ../GMT/topotot.grd -Gappo.grd -R$Longmin/$Longmax/$Latmin/$Latmax -I0.0005 -V
#grdcut appo.grd -Gappoc.grd -R$Longmin/$Longmax/$Latmin/$Latmax
#grdgradient appoc.grd -Gtoppo.grd -A275 -N -V
#grdhisteq toppo.grd -Gombra.grd -N -V
#grdmath ombra.grd 8.0 / = toppo.grd
#grdclip appo.grd -Gclip.grd -Sa0.01/1.0 -Sb-0.01/-1 -V
#grdmath toppo.grd clip.grd x = ombra.grd
#
awk '{print $1,$2,$3}' ../Output/shakemapint.dat | surface -Gdataintens.grd -R$Longmin/$Longmax/$Latmin/$Latmax -I994+/580+ -T$Tens 
#
#grdview dataintens.grd -JM18.00 -C../Palette/Ii.cpt -Qi72 -N0/255/255/255 -Jz0.5e-03 -R -V -K -X3 -Y10 -P > test_trans.ps
#pscoast -JM -R -K -S255/255/255 -W1,0/0/0,. -Df -O >> test_trans.ps
#bboxx -insert test_trans.ps
#bboxx -insert test_trans.ps
#sed -i 's/%%HiResBoundingBox:.*//' test_trans.ps
#convert -transparent white -channel alpha -fx u-0.5 +antialias -density 600 test_trans.ps  test_trans.png
#/bin/mv test_trans.png ../Mappe/mappaintens_trans.png
#rm -f test_trans.ps*
#
#psscale -D3.0/10.0/10/.5h -L -C../Palette/Ii_max.cpt -B1.0f1.0:"Intensity (I@-MM@-)":WSne -K -P > paletta.ps
#bboxx -insert paletta.ps
#bboxx -insert paletta.ps
#sed -i 's/%%HiResBoundingBox:.*//' paletta.ps
#convert +antialias -density 600 -transparent white paletta.ps  paletta.png
#/bin/mv paletta.png ../Mappe/. 
#/bin/rm  paletta.ps*
#
#grdview dataintens.grd -JM18.00 -Ba10mf5m/a10mf5mWSen -C../Palette/Ii.cpt -Qi72 -N0/255/255/255 -Jz0.5e-03 -R -V -I../GMT/ombra.grd -K -X3 -Y10 -P > test.ps
grdview dataintens.grd -JM18.00 -Ba10mf5m/a10mf5mWSen -C../Palette/Imm.cpt -I../GMT/ombra.grd -Qi72 -N0/255/255/255 -Jz0.5e-03 -R -V -K -X3 -Y10 -P > test.ps
#psxy faglia.dat -R -B -JM -O -K -W6 -G0 -M -V >> test.ps 
psxy ../Output/station.dat -JM -R -B -St.3 -G0/0/255 -W1 -K -M -O >> test.ps
psxy ../Parametri/epicentro-mag.dat -JM -R -B -K -V -O -Sa.3 -W5 >> test.ps
#psxy ../GMT/camp_bas_sep_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
pscoast -Lf$scx/$scy/$scy/5 -JM -R -B -K -S120/160/220 -Na/10/102/102/102 -W5 -Df -O >> test.ps 
pstext ../GMT/comuni.txt -JM -R -O -K >> test.ps
#psxy ../GMT/st-flag-acc_gmt.dat -JM -R -B -St.25 -W2 -G255/255/0 -M -O -K >> test.ps
#psxy ../GMT/griglia-fant.dat -R -B -JM -O -K -Sc.1 >> test.ps
awk '{print $1,$2}' ../GMT/comuni.txt | psxy -JM -R -Ss.1 -G0 -O -K >> test.ps
#psxy faglia.dat -R -B -JM -O -G125 -K -W6 -M -V >> test.ps
#psxy ../GMT/baricentri_gmt.dat -R -B -JM -O -Sc.1 -W1/0/0/0 -G255/0/0 -K >> test.ps
#psxy ../GMT/baricentri_gmt.dat -R -B -JM -O -Sx0.15 -K >> test.ps
psscale -D9.0/-2.0/10/.5h -Bwsne -C../Palette/Ii_ntsc.cpt -O -K >> test.ps
pstext -JM -R -O -P -V -K -X1 <<END>> test.ps
10.9 18  10 0 0 LT IIIIII
END
pstext ../Parametri/earthquake.info-int -Jm0.5 -R0/50/0/20 -O -P -V -Y10. -K >> test.ps
#
pstext -Jm -R -O -P -V -Y-21.25 <<END>> test.ps
7.5 18  10 0 0 LT I
9.25 18  10 0 0 LT II-III
12.5 18  10 0 0 LT IV
14.5 18  10 0 0 LT V
16.5 18  10 0 0 LT VI
18.5 18  10 0 0 LT VII
20.5 18  10 0 0 LT VIII
22.5 18  10 0 0 LT IX
24.5 18  10 0 0 LT X+
2.3  17  10 0 0 LT PGV (cm/s) <0.02
9.0  17  10 0 0 LT 0.08
12.5 17  10 0 0 LT 0.3
14.5 17  10 0 0 LT 0.9
16.5 17  10 0 0 LT 2.4
18.5 17  10 0 0 LT 6.4
20.5 17  10 0 0 LT 17
22.5 17  10 0 0 LT 45
24.5 17  10 0 0 LT >120 
2.3  16  10 0 0 LT PGA (%g)  <0.06
9.0  16  10 0 0 LT 0.2
12.5 16  10 0 0 LT 0.8
14.5 16  10 0 0 LT 2.0
16.5 16  10 0 0 LT 4.8
18.5 16  10 0 0 LT 12
20.5 16  10 0 0 LT 29
22.5 16  10 0 0 LT 70
24.5 16  10 0 0 LT >171 
END
#/bin/rm *.grd
/bin/rm pippo* 
#
#bboxx -insert test.ps
#bboxx -insert test.ps
#sed -i 's/%%HiResBoundingBox:.*//' test.ps
#convert test.ps mappaintens.png
#/bin/mv ./mappaintens.png ../Mappe/ 
#/bin/mv test.ps ../Mappe/mappaintens.ps 
#gzip -f ../Mappe/mappaintens.ps
#rm -f test.ps*
#gs -sDEVICE=x11 test.ps
#gs -sDEVICE=x11 ../Mappe/mappaintens.ps
