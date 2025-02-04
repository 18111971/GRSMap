#!/bin/bash 
export LC_ALL=C
#export PATH=/opt/GMT/GMT4.0/bin/:$PATH
#export GMTHOME=/opt/GMT/GMT4.0/
export PATH=/usr/lib/gmt/bin/:$PATH
export GMTHOME=/usr/lib/gmt/

giallo=232/180/0
verde=0/255/0

gmtset PAPER_MEDIA             = a3

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

Mag=`awk '{printf("%2.1f",$3)}' ../Parametri/epicentro-mag.dat`

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
gmtset LABEL_FONT_SIZE         = 12p
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
#
grdview ../GMT/appo.grd -JM23. -R14.25/16.15/40.10/41.55 -Ba60mf30m/a30mf30mWSen -C../Palette/palgrey -Qs -N0/255/255/255 -Jz0.5e-03 -V -I../GMT/ombra.grd -K -Y16 -X2.5 -P > test.ps
psxy ../GMT/camp_bas_sep_wgs.txt -R -B -JM -O -Sc.02 -G125 -K >> test.ps
awk '{print $1-0.01,$2,90.0,100.*$3}' ../Input/input-acc.dat | psxy -R -B -JM -O -W2/125 -G0/215/0 -Sv0.7c/0.0c/0.1c -K -V >> test.ps
awk '{print $1+0.03,$2,90.0,1000.*$3}' ../Input/input-vel.dat | psxy -R -B -JM -O -W2/125 -G$giallo -Sv0.7c/0.0c/0.1c -K -V >> test.ps
pscoast -Lf$scx/$scy/$scy/25 -JM -R -B -K -S120/160/220 -W4/0/0/0 -Di -O >> test.ps 
pstext ../GMT/comuni.txt -JM -G255/0/0 -R -O -K >> test.ps
awk '{print $1,$2}' ../GMT/comuni.txt | psxy -JM -R -Ss.1 -G0 -O -K >> test.ps
psxy ../Parametri/epicentro-mag.dat -JM -R -B -K -V -O -Sa.5 -W5 -G255/0/0 >> test.ps
psxy ../Output/station.dat -JM -R -B -St.25 -W2 -G0 -O -K >> test.ps
awk '{printf "%4.2f %4.2f 13 0 4 LT %4s\n",$1-0.01,$2-0.015,$4}' ../Input/input-acc.dat > testo_staz
pstext testo_staz -R -B -JM -O -G0 -K -V>> test.ps
pstext frame.txt -R -B -JM -O -G0 -V -K -W255/255/255 >> test.ps
psxy -JM -R -B -V -O -Ss0.5 -W2/125 -G$verde -K <<END>> test.ps
15.15 40.30 
END
psxy -JM -R -B -V -O -Ss0.5 -W2/125 -G$giallo -K <<END>> test.ps
15.15 40.25 
END
psxy -JM -R -B -V -O -Sa0.5 -W5 -G255/0/0 -K <<END>> test.ps
15.15 40.20 
END
pstext -JM -R -B -V -O -G0 -K <<END>> test.ps
15.179 40.32 14 0 4 LT PGA (%g) 
15.179 40.27 14 0 4 LT PGV (cm/s) 
15.179 40.22 14 0 4 LT Epicenter  
END
##################################
# Codice per relazione di attenuazione
##################################
#minmax ../Input/obs.dat -C > appomax
paste ../Input/data-input-acc.dat ../Input/data-input-vel.dat | awk '{print $1, $5, $10}' | minmax -C > appomax

crx=`awk '{print $1/1000.0}' appomax`
#cry=`awk '{print $2*10.0}' appomax`
# DEFAULT 
# cry = 150.0
# cay = `awk '{print $4*10.0}' appomax`
# cvy=`awk '{print $6*10.0}' appomax`
cry=400
cax=`awk '{print $3/1000.0}' appomax`
cay=`awk '{print $4*10000.0}' appomax`
cvx=`awk '{print $5/1000.0}' appomax`
cvy=`awk '{print $6*10000.0}' appomax`
psbasemap -JX10l/14l -R0.01/100./0.01/5.0 -G248 -Bwsne -P -O -X16.5 -Y11 -K >> test.ps
psxy -JX -R -Bwsne -Sc.15 -G$verde -W1 -P -O -K <<END>> test.ps
0.05 4.0
END
psxy -JX -R -Bwsne -Sc.15 -G$giallo -W1 -P -O -K <<END>> test.ps
0.1 4.0
END
psxy -JX -R -Bwsne -Sl.4/Current_Recordings -G0 -P -O -K <<END>> test.ps
0.7 4.0
END
psxy -JX -R -Bwsne -Sc.15 -W1 -P -O -K <<END>> test.ps
0.1 3.0
END
psxy -JX -R -Bwsne -Sl.4/Existing_Recordings -G0 -P -O -K <<END>> test.ps
0.7 3.0
END
pstext -JX -R -G0 -P -O -K <<END>> test.ps
0.1 2.3 12 0 0 LT M=$Mag 
END
#
awk '{print $1,$5}' ../Input/data-input-acc.dat | psxy -JX7l/4l -R$crx/$cry/$cax/$cay -Sc.15 -B1a1f3p:"Epicentral dist (km)":/1a1f3p:"Pga (m/s@+2@+)":WSne -P -O -K -Y1.5 -X2 >> test.ps
psxy ../Input/obs.dat -JX -R -Sc.15 -G$verde -W1 -B -P -O -K >> test.ps
awk '{print $1,$3}' ../Input/cal.dat | psxy -JX -R -B -P -O -K -W2/0/0/0t10_10:0 >> test.ps
awk '{print $1,$4}' ../Input/cal.dat | psxy -JX -R -B -P -O -K -W2/0/0/0t10_10:0 >> test.ps
psxy ../Input/cal.dat -JX -R -B -P -O -K -W2 >> test.ps
#
awk '{print $1,$5}' ../Input/data-input-vel.dat |  psxy -JX -R$crx/$cry/$cvx/$cvy -Sc.15 -B1a1f3p:"Epicentral dist (km)":/1a1f3p:"Pgv (m/s)":WSne -P -O -Y5.7 -K >> test.ps
awk '{print $1,$3}' ../Input/obs.dat |  psxy -JX -R -Sc.15 -W1 -G$giallo -B -P -O -K >> test.ps
awk '{print $1,$5}' ../Input/cal.dat | psxy -JX -R -B -P -O -K -W2 >> test.ps
awk '{print $1,$6}' ../Input/cal.dat | psxy -JX -R -B -P -O -K -W2/0/0/0t10_10:0 >> test.ps
awk '{print $1,$7}' ../Input/cal.dat | psxy -JX -R -B -P -O -W2/0/0/0t10_10:0 >> test.ps
##################################
bboxx -insert -pad 20 test.ps
sed -i 's/%%HiResBoundingBox:.*//' test.ps
convert test.ps PGOBS.png
rm -f test.ps~
/bin/mv PGOBS.png ../Mappe/.
/bin/mv test.ps ../Mappe/PGOBS.ps
gzip -f ../Mappe/PGOBS.ps
#/bin/rm *.grd
/bin/rm pippo*
#
#gs -sDEVICE=x11 test.ps
