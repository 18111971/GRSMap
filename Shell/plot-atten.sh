
gmtset ANNOT_FONT_SIZE = 16p
gmtset LABEL_FONT_SIZE = 16p
#
makecpt -T100/1000/1 -Cseis > palettaVS30
#
#------------------------------------------------------------------------------------
#
awk '{print $1,$2}' ../Output/cal.dat | psxy -JX11l/11l -R0.01/30/1.e-5/1.0 -W4/0/255/0 -B1a1f3:"Hypocentral distance (km)":/1a1f3:"PGA (m/s@+2@+)":WSne -P -K -Y5 -X6> d.ps
awk '{print $1,$3}' ../Output/cal.dat | psxy -JX -R -W4/0/255/0t10_10:0.0 -B -P -K -O>> d.ps
awk '{print $1,$4}' ../Output/cal.dat | psxy -JX -R -W4/0/255/0t10_10:0.0 -B -P -K -O>> d.ps
awk '{print $1,$2,$4}' ../Output/obs_pga_pgv.dat | psxy -JX -R -Sc.3 -CpalettaVS30 -B -P -K -O>> d.ps
#
awk '{print $1,$5}' ../Output/cal.dat | psxy -JX -R0.01/30/1.e-6/0.01 -W4/0/255/0 -B1a1f3:"Hypocentral distance (km)":/1a1f3p:"PGV (m/s)":WSne -P -K -O -Y14>> d.ps
awk '{print $1,$6}' ../Output/cal.dat | psxy -JX -R -W4/0/255/0t10_10:0.0 -B -P -K -O>> d.ps
awk '{print $1,$7}' ../Output/cal.dat | psxy -JX -R -W4/0/255/0t10_10:0.0 -B -P -K -O>> d.ps
awk '{print $1,$3,$4}' ../Output/obs_pga_pgv.dat | psxy -JX -R -Sc.3 -CpalettaVS30 -B -P -K -O>> d.ps
#
psscale -D0.5/3.0/5/0.5 -CpalettaVS30 -B200f100:"Vs30":WSne -O >> d.ps
exit
awk '{print $1,$2}' pga_dist.dat_Q_300 | psxy -JX -R -W3/255/0/0 -B -P -K -O >> d.ps
awk '{print $1,$2}' sab_pga.dat | psxy -JX -R -W5/255/0/0 -B -P -K -O >> d.ps
awk '{print $1,$2}' pga_emolo.dat | psxy -JX -R -W5/0/0/255 -B -P -K -O >> d.ps
awk '{print $1,$2}' pga_zuccolo.dat | psxy -JX -R -W5/255/0/255 -B -P -K -O >> d.ps
awk '{print $1,$2}' atten_massa.dat | psxy -JX -R -W5/0/255/255 -B -P -K -O >> d.ps
awk '{print $1,10.**$2}' atten_logpa.dat | psxy -JX -R -W5 -B -P -K -O >> d.ps
#
psxy -JX -R -W5t10_10:0.0 -B -P -O -K <<END>> d.ps
8.0 12.5
80.0 1.25
END
pstext -JX -R -P -O -K <<END>> d.ps
10.0 20.0 14 0 0 LT r@+-1@-
END
#
gs -sDEVICE=x11 d.ps
