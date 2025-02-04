
gmtset LABEL_FONT_SIZE = 12
gmtset ANOT_FONT_SIZE = 9

psscale -D1.0/1./15/.5h -Cpal_pga_da_Imm  -L -E -B10.0f5:"Pga (%g)":WSne -P -X10 -Y10 > paletta_pga.ps
psscale -D1.0/1./15/.5h -Cpal_pgv_da_Imm -L -E -B10.0f5:"Pgv (cm/s)":WSne -P -X10 -Y10 > paletta_pgv.ps 
#
#gs -sDEVICE=x11 d.ps 
