.title '6T SRAM Cell READ Operation using UCSB 2D Cryo CMOS'
.hdl Cryo_Si_AK.va
.hdl Cryo_MoS2_AK.va
.hdl Cryo_WS2_AK.va
.hdl CuWire.va

.param VDDVAL = 0.2
.param Rvia=6.274e+01
.param Lwire=1.000e-05
.param Wwire=1.800e-08
.param Hwire=3.600e-08
.param rouwire=5.776e-08
.param cwire=1.388e-10

VDD vdd gnd VDDVAL
VSS gnd 0 0

* Precharge both bitlins to VDD

* VBL    bl    gnd VDDVAL
* VBARBL barbl gnd VDDVAL

* VBLDRV   bldrv 0    VDDVAL          
* VBARBL   barbl 0    VDDVAL        


Rvia1    bl bl_int Rvia
XwireBL  bl_int blwire_end CuWire l=Lwire w=Wwire h=Hwire rou=rouwire C=cwire
Rvia2    blwire_end  blterm Rvia 
* blterm net is left floating. 

* Word Line Pulse to enable access
VWL wl gnd PULSE(0 0.2 10ns 200ps 200ps 20ns 40ns)

* Initial condition: read 0 out of SRAM (so start Q = 0)
.IC   V(Q)=0      V(QB)=0.2      \
      V(bl)=VDDVAL  V(barbl)=VDDVAL


CBL      bl      0      1p
CBLB     barbl   0      1p

* Cross-coupled inverters
Xpd1 gnd Q  QB Cryo_WS2_AK Type=1 W=3.800e-08 L=1.800e-08 T=4 absTol=1.000e-08
Xpd2 gnd QB Q  Cryo_WS2_AK Type=1 W=3.800e-08 L=1.800e-08 T=4 absTol=1.000e-08

Xpu1 vdd Q  QB Cryo_WS2_AK Type=-1 W=1.800e-08 L=1.800e-08 T=4 absTol=1.000e-08
Xpu2 vdd QB Q  Cryo_WS2_AK Type=-1 W=1.800e-08 L=1.800e-08 T=4 absTol=1.000e-08

* Access Transistors
Xacc1 Q  bl    wl Cryo_WS2_AK Type=1 W=5.800e-08 L=1.800e-08 T=4 absTol=1.000e-08
Xacc2 QB barbl wl Cryo_WS2_AK Type=1 W=5.800e-08 L=1.800e-08 T=4 absTol=1.000e-08




.TRAN 0.01ns 40ns UIC
.options post=2 nomod

* .meas TRAN t_in   TRIG V(wl)  VAL=0.1  RISE=1
* .meas TRAN t_bl   TARG V(bl)  VAL=VDDVAL-0.02 FALL=1  
* .meas TRAN BL_delay PARAM 't_bl - t_in'

.meas TRAN avg_curr AVG I(VDD) FROM=8n  TO=20n
.meas TRAN Ewrite INTEGRAL '-V(VDD)*I(VDD)' FROM=8n TO=20n
.END
