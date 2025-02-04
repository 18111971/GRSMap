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
 
/bin/rm ../Output/griglia-pga.dat ../Output/griglia-pgv.dat
/bin/rm ../Output/griglia-sa1.dat ../Output/griglia-sa03.dat ../Output/griglia-sa3.dat

nl=`wc -l ../Output/griglia-optima.dat | awk '{print $1}'`
echo $nl
i=1
while [ $i -le $nl ];
do
echo $i of $nl
lon=`sed -n $i\p ../Output/griglia-optima.dat | awk '{print $1}'`
lat=`sed -n $i\p ../Output/griglia-optima.dat | awk '{print $2}'`
pga=`sed -n $i\p ../Output/griglia-optima.dat | awk '{print $3}'`
pgv=`sed -n $i\p ../Output/griglia-optima.dat | awk '{print $4}'`
#echo $lon $lat $pgv
echo $lon $lat > tmp
/bin/rm tmp1
grdtrack tmp -G../VS30/vs30_cf.grd -Qc -R14.03387/14.24228/40.77891/40.91259 > tmp1
if [ -s tmp1 ]
then
vs=`awk '{print int($3)}' tmp1`
else
vs=1000
fi
echo $lon $lat $pga $vs >> ../Output/griglia-pga.dat
echo $lon $lat $pga $vs >> ../Output/griglia-sa1.dat
echo $lon $lat $pga $vs >> ../Output/griglia-sa03.dat
echo $lon $lat $pga $vs >> ../Output/griglia-sa3.dat
echo $lon $lat $pgv $vs >> ../Output/griglia-pgv.dat
let i=i+1
done
exit


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

