.title '6T SRAM Cell READ Operation using UCSB 2D Cryo CMOS'
.hdl Cryo_Si_AK.va
.hdl Cryo_MoS2_AK.va
.hdl Cryo_WS2_AK.va
.hdl CuWire.va

.param VDDVAL = 0.4
.param Rvia=6.274e+01
.param Lwire=1.000e-05
.param Wwire=1.800e-08
.param Hwire=3.600e-08
.param rouwire=5.776e-08
.param cwire=1.388e-10

VDD vdd gnd VDDVAL

.param Tsim = 4

* Precharge both bitlins to VDD

* VBL    bl    gnd VDDVAL
* VBARBL barbl gnd VDDVAL

* VBLDRV   bldrv 0    VDDVAL          
* VBARBL   barbl 0    VDDVAL        


* Rvia1    bl bl_int Rvia
* XwireBL  bl_int blwire_end CuWire l=Lwire w=Wwire h=Hwire rou=rouwire C=cwire
* Rvia2    blwire_end  blterm Rvia 
* blterm net is left floating. 

* Hold word-line high for the static read condition  
VWL wl gnd DC=0 

* Initial condition: read 0 out of SRAM (so start Q = 0)
* .IC   V(Q)=VDDVAL     V(QB)=0      \
*       V(bl)=VDDVAL        V(barbl)=VDDVAL

.IC V(bl) = VDDVAL  V(barbl) = VDDVAL

.nodeset V(QBD)=0
.nodeset V(QD)=VDDVAL


* Cross-coupled inverters
Xpd1 gnd QD  QB Cryo_WS2_AK Type=1 W=3.800e-08 L=1.800e-08 T=Tsim absTol=1.000e-08
Xpd2 gnd QBD Q  Cryo_WS2_AK Type=1 W=3.800e-08 L=1.800e-08 T=Tsim absTol=1.000e-08

Xpu1 vdd QD  QB Cryo_WS2_AK Type=-1 W=1.800e-08 L=1.800e-08 T=Tsim absTol=1.000e-08
Xpu2 vdd QBD Q  Cryo_WS2_AK Type=-1 W=1.800e-08 L=1.800e-08 T=Tsim absTol=1.000e-08

* Access Transistors
Xacc1 QD  bl    wl Cryo_WS2_AK Type=1 W=5.800e-08 L=1.800e-08 T=Tsim absTol=1.000e-08
Xacc2 QBD barbl wl Cryo_WS2_AK Type=1 W=5.800e-08 L=1.800e-08 T=Tsim absTol=1.000e-08


* .param VSWP = 0

* * Vinj   Q   gnd DC=VSWP
* * Vinjb  QB  gnd DC='VDDVAL - VSWP'

* .DC VSWP 0  VDDVAL  0.001
* record both voltages
* .PRINT  DC  V(Q)  V(QB)


* sweep variable U runs from –VDD/√2 to +VDD/√2
.PARAM  U = 0
.PARAM  UL = '-VDDVAL/sqrt(2)'
.PARAM  UH = 'VDDVAL/sqrt(2)'

EQ  Q   gnd VOL='1/sqrt(2)*U + 1/sqrt(2)*V(V1)'
EQB  QB   gnd VOL='-1/sqrt(2)*U + 1/sqrt(2)*V(V2)'


* VCVS to form rotated coordinates V1 and V2
EV1   V1   gnd   VOL= ' U  + sqrt(2)*V(QBD) '
EV2   V2   gnd   VOL= '-U + sqrt(2)*V(QD) '

* * absolute-difference diode: length of diagonal of inscribed square
EVD   VD   gnd   VOL= 'ABS(V(V1) - V(V2)) '

* * Sweep the “noise‐injection” coordinate U
.DC   U   UL   UH   0.001

* * Capture the rotated-difference (diagonal) at each step
.PRINT  DC  V(Q)  V(QB) V(V1) V(V2)

* * Find the maximum diagonal over the sweep
.MEASURE DC  MAXVD  MAX  V(VD)

* * Convert diagonal → SNM (side of square = diagonal/√2)
.MEASURE DC  SNM   PARAM='1/sqrt(2)*MAXVD '



.options nomod post=2

* .meas TRAN t_in   TRIG V(wl)  VAL=0.1  RISE=1
* .meas TRAN t_bl   TARG V(bl)  VAL=VDDVAL-0.02 FALL=1  
* .meas TRAN BL_delay PARAM 't_bl - t_in'

* .meas TRAN avg_curr AVG I(VDD) FROM=8n  TO=20n
* .meas TRAN Ewrite INTEGRAL '-V(VDD)*I(VDD)' FROM=8n TO=20n
.END
