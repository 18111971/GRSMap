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

scx=`awk '{if( $1 lt 0.0) print $1+0.4 }' pippo`
scy=`awk '{if( $3 lt 0.0) print $3+0.3 }' pippo`

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
gmtset ANNOT_FONT_PRIMARY      = Times-Roman
gmtset LABEL_FONT_SIZE         = 10p
gmtset ANNOT_FONT_SIZE         = 10p
#
#xyz2grd ../GMT/it_mer.xyz -Girpinia.grd -I8.333333333300e-03 -R12/18/39/44 -V
#grdcut irpinia.grd -Gappo.grd -R$Longmin1/$Longmax1/$Latmin1/$Latmax1 -V
#grdsample irpinia.grd -Gappo.grd -R$Longmin1/$Longmax1/$Latmin1/$Latmax1 -I8.333333333300e-03 -V
#grdgradient appo.grd -Gtoppo.grd -A270 -N -V
#grdhisteq toppo.grd -Gombra.grd -N -V
#grdmath ombra.grd 8.0 / = toppo.grd
#grdclip appo.grd -Gclip.grd -Sa0.01/1.0 -Sb0.01/0.0 -V
#grdmath toppo.grd clip.grd x = ombra.grd
#
awk '{print $1,$2,$3}' ../Output/mappa-iso-pgx.dat | surface -Gdata.grd -R$Longmin/$Longmax/$Latmin/$Latmax -I0.01 -T$Tens  
#
#grdview data.grd -JM14.25 -R -C../Palette/palpga1 -Qs -Jz0.5e-03 -N0/255/255/255 -V -P -Y8 -X3 -K > test_trans.ps
grdview data.grd -JM14.25 -R -C../Palette/pal_pga_da_Imm -Qs -Jz0.5e-03 -N0/255/255/255 -V -P -Y8 -X3 -K > test_trans.ps
#grdview data.grd -JM14.25 -R -C../Palette/newpalpgag -Qs -Jz0.5e-03 -I../GMT/ombra.grd -N0/255/255/255 -V -P -Y8 -X3 -K > test_trans.ps
pscoast -JM -R -S255/255/255 -W1,0/0/0,. -Di -O -K >> test_trans.ps
bboxx -insert test_trans.ps
bboxx -insert test_trans.ps
sed -i 's/%%HiResBoundingBox:.*//' test_trans.ps
convert -channel alpha -fx u-0.5 +antialias -density 600 -transparent white test_trans.ps  test_trans.png
/bin/mv test_trans.png ../Mappe/PGA_trans_color.png
/bin/rm  test_trans.ps*
#
#/bin/rm .gmtcommands*
#
export LC_ALL=C
export PATH=/opt/GMT/GMT4.0/bin/:$PATH
export GMTHOME=/opt/GMT/GMT4.0/
#
gmtset ANNOT_FONT_PRIMARY      = Times-Roman
gmtset LABEL_FONT_SIZE         = 10p
gmtset ANNOT_FONT_SIZE         = 10p
#
#grdview data.grd -JM14.25 -Ba60mf30m/a30mf30mWSen -C../Palette/palpga1 -Qs -N0/255/255/255 -Jz0.5e-03 -R -V -I../GMT/ombra.grd -K -Y8 -X3 -P > test.ps
#grdview ../GMT/appo.grd -JM14.25 -Ba60mf30m/a30mf30mWSen -C../Palette/tan.cpt -Qs -N0/255/255/255 -Jz0.5e-03 -R -V -I../GMT/ombra.grd -K -Y8 -X3 -P > test.ps

grdview ../GMT/appo.grd -JM14.25 -Ba60mf30m/a30mf30mWSen -C../Palette/tan.cpt -Qs -N0/255/255/255 -Jz0.5e-03 -R$Longmin/$Longmax/$Latmin/$Latmax -V -I../GMT/ombra.grd -K -Y8 -X3 -P > test.ps
#grdcontour data.grd -JM14.25 -R$Longmin/$Longmax/$Latmin/$Latmax -Ba60mf30m/a30mf30mWSen  -CcontourPGA.dat -A -W4 -K -V > test.ps
grdcontour data.grd -JM -R -B -CcontourPGA.dat -A -W4 -O -K -V >> test.ps
psxy ../GMT/camp_bas_sep_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
pscoast -Lf$scx/$scy/$scy/50 -JM -R -B -K -S120/160/220 -W4/0/0/0 -Di -O >> test.ps 
pstext ../GMT/comuni.txt -JM -R -O -K >> test.ps
awk '{print $1,$2}' ../GMT/comuni.txt | psxy -JM -R -Ss.1 -G0 -O -K >> test.ps
psxy ../Parametri/epicentro-mag.dat -JM -R -B -K -V -O -Sa.3 -W5 -G255/0/0 >> test.ps
psxy ../Output/station.dat -JM -R -B -St.25 -G0 -M -O -K >> test.ps
#psxy ../GMT/st-flag-acc_gmt.dat -JM -R -B -St.25 -W2 -G255/255/0 -M -O -K >> test.ps
#awk '{print $1,$2}' ../Output/mappa-iso-pgx.dat |  psxy -R -B -JM -O -K -Sc.1 >> test.ps
#psxy ../GMT/baricentri_gmt.dat -R -B -JM -O -Sc.1 -G255/0/0 -K >> test.ps
#psxy ../GMT/baricentri_gmt.dat -R -B -JM -O -Sx0.15/+ -K >> test.ps
#
pstext ../Parametri/earthquake.info-pga -JM0.5 -R0/50/0/20 -O -P -V -Y10.0 >> test.ps
#
bboxx -insert test.ps
bboxx -insert test.ps
convert test.ps PGA_color.png 
sed -i 's/%%HiResBoundingBox:.*//' test.ps
/bin/mv PGA_color.png ../Mappe/.
/bin/mv test.ps ../Mappe/PGA_color.ps
rm -f test.ps*
gzip -f ../Mappe/PGA_color.ps
/bin/rm *.grd
/bin/rm pippo* 
#
#gs -sDEVICE=x11 ../Mappe/PGA.ps
