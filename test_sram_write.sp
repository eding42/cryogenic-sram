.title '6T SRAM Cell Write Operation using UCSB 2D Cryo CMOS'
.hdl Cryo_Si_AK.va
.hdl Cryo_MoS2_AK.va
.hdl Cryo_WS2_AK.va

VDD vdd gnd 0.2
VSS gnd 0 0

* Drive Bitlines for Write Operation
VBL    bl    gnd 0.2
VBARBL barbl gnd 0

* Word Line Pulse to enable access
VWL wl gnd PULSE(0 0.2 10ns 200ps 200ps 20ns 40ns)

* Initial condition: Write 1 into Q (so start Q = 0)
.IC V(Q)=0  V(QB)=0.2

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
.meas TRAN avg_curr AVG I(VDD)
.meas TRAN Ewrite INTEGRAL '-V(VDD)*I(VDD)' FROM=8n TO=20n
.END
