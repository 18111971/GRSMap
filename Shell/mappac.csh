export LC_ALL=C
#export PATH=/opt/GMT/GMT4.0/bin/:$PATH
#export GMTHOME=/opt/GMT/GMT4.0/
export PATH=/usr/lib/gmt/bin/:$PATH
export GMTHOME=/usr/lib/gmt/

gmtset HEADER_FONT_SIZE        = 18p

sed -n 20p ../Parametri/configure.txt > pippo1
sed -n 21p ../Parametri/configure.txt > pippo2
sed -n 22p ../Parametri/configure.txt > pippo3
sed -n 23p ../Parametri/configure.txt > pippo4
sed -n 37p ../Parametri/configure.txt > pippo5
sed -n 43p ../Parametri/configure.txt > pippo6
sed -n 47p ../Parametri/configure.txt > pippo7

paste pippo1 pippo2 pippo3 pippo4 pippo5 pippo6 pippo7 > pippo

dig=`awk '{print $5}' pippo`
Tens=`awk '{print $6}' pippo`
Ncont=`awk '{print $7}' pippo`

Longmin=`awk '{printf ("%3.3f",$1)}' pippo`
Longmax=`awk '{printf ("%3.3f",$2)}' pippo`
Latmin=`awk '{printf ("%3.3f",$3)}' pippo`
Latmax=`awk '{printf ("%3.3f",$4)}' pippo`

scx=`awk '{if( $1 lt 0.0) print $1+0.4 }' pippo`
scy=`awk '{if( $3 lt 0.0) print $3+0.05 }' pippo`

echo SCX $scx SCY $scy

Longmin1=`awk '{printf ("%3.3f",$1)}' pippo`
Longmax1=`awk '{printf ("%3.3f",$2)}' pippo`
Latmin1=`awk '{printf ("%3.3f",$3)}' pippo`
Latmax1=`awk '{printf ("%3.3f",$4)}' pippo`

#nc=`awk '{print $2}' ../GMT/line-contour.dat`
#nca=`awk '{printf("%4.2f\n", $2)}' ../GMT/line-contour.dat`

#nc=`sed -n 1p contourPGA.dat | awk '{printf("%6.3f\n",$1)}'`
#na=`sed -n 1p contourPGA.dat | awk '{printf("%6.3f\n",$2)}'`
nc=`sed -n 1p contourPGA.dat | awk '{print $1}'`
na=`sed -n 1p contourPGA.dat | awk '{print $2}'`

echo $nc $na

echo '################################'
echo $nc
echo $na
echo $Longmin1
echo $Longmax1 
echo $Latmin1
echo $Latmax1 
echo $Longmin
echo $Longmax 
echo $Latmin
echo $Latmax 
echo $dig
echo $Tens 
echo $Ncont  
echo '################################'

#
gmtset ANNOT_FONT_PRIMARY      = Times-Roman
gmtset LABEL_FONT_SIZE         = 10p
gmtset ANNOT_FONT_SIZE         = 10p
#
#xyz2grd ../GMT/it_mer.xyz -Girpinia.grd -I8.333333333300e-03 -R12/18/39/44 -V
#grdcut irpinia.grd -Gappo.grd -R$Longmin1/$Longmax1/$Latmin1/$Latmax1 -V
#grdsample irpinia.grd -Gappo.grd -R$Longmin1/$Longmax1/$Latmin1/$Latmax1 -I0.01 -V
#grdgradient appo.grd -Gtoppo.grd -A270 -N -V
#grdhisteq toppo.grd -Gombra.grd -N -V
#grdmath ombra.grd 8.0 / = toppo.grd
#grdclip appo.grd -Gclip.grd -Sa0.01/1.0 -Sb0.01/0.0 -V
#grdmath toppo.grd clip.grd x = ombra.grd

awk '{print $1,$2,$3}' ../Output/shakemapacc.dat | surface -Gdata.grd -R$Longmin/$Longmax/$Latmin/$Latmax -I994+/580+ -T$Tens  
#
#grdcontour data.grd -JM18 -R -CcontourPGV.dat -A -W4/255/0/0 -V -P -Y8 -X3 -K > test_trans.ps
#pscoast -JM -R -K -S255/255/255 -W3,0/0/0,. -Df -O >> test_trans.ps
#bboxx -insert test_trans.ps
#bboxx -insert test_trans.ps
#sed -i 's/%%HiResBoundingBox:.*//' test_trans.ps
#convert +antialias -density 600 -transparent white test_trans.ps test_trans.png
#/bin/mv test_trans.png ../Mappe/PGV_trans.png
#/bin/rm  test_trans.ps*
#
grdview ../GMT/toppo.grd -JM18 -Ba10mf5m/a10mf5mWSen -C../Palette/paletta_campi -Qs -N0/255/255/255 -Jz0.5e-03 -R -V -I../GMT/ombra.grd -K -Y8 -X3 -P > test.ps
grdcontour data.grd -JM -R -B -C$nc -A$na+g -W4/255/255/0 -O -K >> test.ps
#grdcontour data.grd -JM -R -B -C0.05 -A0.1+g -W4/255/255/0 -O -K >> test.ps
#psxy ../GMT/camp_bas_sep_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
#psxy ../GMT/puglia_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
#psxy ../GMT/lazio_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
#psxy ../GMT/calabria_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
#psxy faglia.dat -R -B -JM -O -G125 -K -W6 -M >> test.ps
pscoast -Lf$scx/$scy/$scy/5 -JM -R -B -K -S120/160/220 -W4 -Df -O >> test.ps 
pstext ../GMT/comuni.txt -JM -R -O -K >> test.ps
awk '{print $1,$2}' ../GMT/comuni.txt | psxy -JM -R -Ss.1 -G0 -O -K >> test.ps
psxy ../Parametri/epicentro-mag.dat -JM -R -B -K -V -O -Sa.3 -W5 -G255/0/0 >> test.ps
psxy ../Output/station.dat -JM -R -B -St.3 -G0/0/255 -M -O -K >> test.ps
#psxy ../GMT/st-flag-vel_gmt.dat -JM -R -B -St.25 -W2 -G255/255/0 -M -O -K >> test.ps
psxy ../GMT/griglia-fant.dat -R -B -JM -O -K -Sc.1 >> test.ps
psxy ../GMT/baricentri_gmt.dat -R -B -JM -O -Sc.1 -G255/0/0 -K >> test.ps
psxy ../GMT/baricentri_gmt.dat -R -B -JM -O -Sx0.15/+ -K >> test.ps
pstext ../Parametri/earthquake.info-pga -Jm0.5 -R0/50/0/20 -O -P -V -Y10.5 >> test.ps
#
#bboxx -insert test.ps
#bboxx -insert test.ps
#sed -i 's/%%HiResBoundingBox:.*//' test.ps
#convert test.ps PGV.png
#/bin/mv PGV.png ../Mappe/.
#/bin/mv test.ps ../Mappe/PGV.ps
#gzip -f ../Mappe/PGV.ps
#rm -f test.ps*
#/bin/rm *.grd
#/bin/rm pippo*
#
#gs -sDEVICE=x11 test.ps
