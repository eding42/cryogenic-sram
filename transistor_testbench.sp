.title "Cryo_MoS2_AK Characterization"

.hdl CuWire.va
.hdl Cryo_Si_AK.va
.hdl Cryo_MoS2_AK.va
.hdl Cryo_WS2_AK.va

.param vddp = 0.5

* set constant gate bias here
.param VGS_const = 0.1  


* Gate and Drain voltage sources (will be swept)
VGS gate 0 DC VGS_const
VDS drain 0 DC 0

* gate length and width can be changed, T = 4 K 
XU1 0 drain gate Cryo_MoS2_AK Type=1 W=1.800e-08 L=1.800e-08 T=4 absTol=1.000e-08

.options nomod post=2

* sweep VDS only
.dc VDS 0 vddp 0.0005

* record drain current
.print dc I(VDS)

.end
