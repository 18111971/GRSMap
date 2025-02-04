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
sed -n 14p ../Parametri/configure.txt > pippo7


paste pippo1 pippo2 pippo3 pippo4 pippo5 pippo6 pippo7 > pippo


di=`awk '{print $5}' pippo`
Tens=`awk '{print $6}' pippo`
qvtm=`awk '{print $7}' pippo`


#xmin=`awk '{printf ("%3.2f",$1)}' pippo`
#xmax=`awk '{printf ("%3.2f",$2)}' pippo`
#ymin=`awk '{printf ("%3.2f",$3)}' pippo`
#ymax=`awk '{printf ("%3.2f",$4)}' pippo`

xmin=`awk '{printf ("%3.2f",$1)}' ./../Output/griglia-buf.dat`
xmax=`awk '{printf ("%3.2f",$2)}' ./../Output/griglia-buf.dat`
ymin=`awk '{printf ("%3.2f",$3)}' ./../Output/griglia-buf.dat`
ymax=`awk '{printf ("%3.2f",$4)}' ./../Output/griglia-buf.dat`


echo '#### Lat Long ########'
echo 'Lat min='$xmin
echo 'Lat max='$xmax 
echo 'Long min='$ymin
echo 'Long max='$ymax 
echo '######################'
echo '####### di Tens ######'
echo 'Tens='$Tens
echo '######################'
echo '######### qvtm #######'
echo 'qtm='$qvtm 
echo '######################'
  

#xo=`echo $xmin $di | awk '{printf("%.3f", $1-0.5*$2)}'`
#yo=`echo $ymin $di | awk '{printf("%.3f", $1-0.5*$2)}'`

xminam=13.80
xmaxam=14.33
yminam=40.66
ymaxam=41.00


xo=`echo $xminam 0.01 | awk '{printf("%.3f", $1-0.5*$2)}'`
yo=`echo $yminam 0.01 | awk '{printf("%.3f", $1-0.5*$2)}'`

#lx=`echo $xmax $xo $di | awk '{printf("%.3f", ($1-$2)+$3)}'`
#ly=`echo $ymax $yo $di | awk '{printf("%.3f", ($1-$2)+$3)}'`

lx=`echo $xmax $xo 0.01 | awk '{printf("%.3f", ($1-$2)+$3)}'`
ly=`echo $ymax $yo 0.01 | awk '{printf("%.3f", ($1-$2)+$3)}'`

echo '######## Origine ##############'
echo $xo
echo $yo
echo '############ Lx Ly ############'
echo $lx
echo $ly
echo '###############################'

################################################################
#  Poiche' il criterio di campionamento fra mapcolr e surface e' 
#  diverso, l'origine nel mapcolor deve essere schiftata della 
#  meta' del passo di campionamento del surface 
#  Rxmin/xmax/ymin/ymax -> ORIGIN xo=xmin-(dx/2) yo=ymin-(dy/2)
#  xsize=(xmax-xo)+dx
#  ysize=(ymax-yo)+dx
################################################################

#awk '{print $1,$2,$3}' ./../Output/griglia-optima.dat | surface -Ggrigliac.grd -R$xmin/$xmax/$ymin/$ymax -I$di -T$Tens 
#./Shell/mapcolor.exe ./GMT/mappa.bmp -ORIGIN $xo $yo -SIZE $lx $ly -GRID $di $di > prova.txt 

blockmean ../Output/griglia-optima.dat -R$xmin/$xmax/$ymin/$ymax -I0.01 > acc_tmp.xyz 
surface acc_tmp.xyz -Ggrigliac.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  

awk '{print $1,$2,$4}' ../Output/griglia-optima.dat |  blockmean -R$xmin/$xmax/$ymin/$ymax -I0.01 > vel_tmp.xyz 
surface vel_tmp.xyz -Ggrigliav.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  

awk '{print $1,$2,$5}' ../Output/griglia-optima.dat |  blockmean -R$xmin/$xmax/$ymin/$ymax -I0.01 > sa03_tmp.xyz 
surface sa03_tmp.xyz -Ggrigliasa03.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  

awk '{print $1,$2,$6}' ../Output/griglia-optima.dat |  blockmean -R$xmin/$xmax/$ymin/$ymax -I0.01 > sa1_tmp.xyz 
surface sa1_tmp.xyz -Ggrigliasa1.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  

awk '{print $1,$2,$7}' ../Output/griglia-optima.dat |  blockmean -R$xmin/$xmax/$ymin/$ymax -I0.01 > sa3_tmp.xyz 
surface sa3_tmp.xyz -Ggrigliasa3.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  

echo surface -Ggrigliac.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens   
echo surface -Ggrigliav.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens   
echo surface -Ggrigliasa03.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  
echo surface -Ggrigliasa1.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  
echo surface -Ggrigliasa3.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 -T$Tens  

grdsample grigliac.grd -Gtmpa.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 
grd2xyz tmpa.grd -R$xmin/$xmax/$ymin/$ymax > grigliac.txt
awk '{print $1,$2,$3,-1}' grigliac.txt > appo1 
/bin/mv appo1 ../Output/griglia-pga.dat

grdsample grigliav.grd -Gtmpv.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 
grd2xyz tmpv.grd -R$xmin/$xmax/$ymin/$ymax > grigliav.txt
awk '{print $1,$2,$3,-1}' grigliav.txt > appo2 
/bin/mv appo2 ../Output/griglia-pgv.dat
#
grdsample grigliasa03.grd -Gtmpsa03.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 
grd2xyz tmpsa03.grd -R$xmin/$xmax/$ymin/$ymax > grigliasa03.txt
awk '{print $1,$2,$3,-1}' grigliasa03.txt  > appo3 
/bin/mv appo3 ../Output/griglia-sa03.dat
#
grdsample grigliasa1.grd -Gtmpsa1.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 
grd2xyz tmpsa1.grd -R$xmin/$xmax/$ymin/$ymax > grigliasa1.txt
awk '{print $1,$2,$3,-1}' grigliasa1.txt  > appo4 
/bin/mv appo4 ../Output/griglia-sa1.dat
#
grdsample grigliasa3.grd -Gtmpsa3.grd -R$xmin/$xmax/$ymin/$ymax -I0.01 
grd2xyz tmpsa3.grd -R$xmin/$xmax/$ymin/$ymax > grigliasa3.txt
awk '{print $1,$2,$3,-1}' grigliasa3.txt  > appo5 
/bin/mv appo5 ../Output/griglia-sa3.dat

#/bin/rm ../Output/griglia-app.dat 
/bin/rm ./*.grd
/bin/rm ./*.txt 
/bin/rm ./*.xyz  
/bin/rm pippo* 
#/bin/rm prova.txt

