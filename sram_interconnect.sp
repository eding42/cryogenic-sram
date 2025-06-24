title 'inv'

.hdl CuWire.va
.hdl Cryo_Si_AK.va
.hdl Cryo_MoS2_AK.va
.hdl Cryo_WS2_AK.va

.param vddp=0.2
.param Rvia=6.274e+01

.param Lwire=1.000e-05
.param Wwire=1.800e-08
.param Hwire=3.600e-08
.param rouwire=5.776e-08
.param cwire=1.388e-10

vm vm 0 vddp
vdd vdd 0 vddp
vin in1 0 pulse 0 vddp 250ps 0.1ps 0.1ps 500ps 1ns

* first inverter
Xn1 0 out1 in1 Cryo_MoS2_AK Type=1 W=1.800e-08 L=1.800e-08 T=4.000e+01 absTol=1.000e-08
Xp1 vm out1 in1 Cryo_MoS2_AK Type=-1 W=1.800e-08 L=1.800e-08 T=4.000e+01 absTol=1.000e-08
* 0V Voltage Source
Vprobe out1 out11 0

* Via 1
Rvia1 out11 out111 Rvia

* Cu wire
Xwire out111 in22 CuWire l=LWire w=Wwire h=Hwire rou=rouwire C=cwire

* Via 2
Rvia2 in22 in2 Rvia

* second inverter
Xn2 0 out2 in2 Cryo_MoS2_AK Type=1 W=7.200e-08 L=1.800e-08 T=4.000e+01 absTol=1.000e-08
Xp2 vdd out2 in2 Cryo_MoS2_AK Type=-1 W=7.200e-08 L=1.800e-08 T=4.000e+01 absTol=1.000e-08

.options post=2 nomod
.op
.dc vin 0.00 vddp 0.01
.tran 0.01ps 1ns
*.PRINT I(Vprobe)
.MEAS TRAN delaylh TRIG V(in1) VAL='vddp/2' RISE=1 TARG V(out2) VAL='vddp/2' RISE=1
.MEAS TRAN delayhl TRIG V(in1) VAL='vddp/2' FALL=1 TARG V(out2) VAL='vddp/2' FALL=1
.MEAS TRAN delay_eq PARAM='(delaylh+delayhl)/2'
.MEAS TRAN P_avg AVG POWER FROM=0ns TO=1ns
.END