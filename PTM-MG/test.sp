*for testing the multigate PTM models
.lib './models' ptm20hp

vdd vdd 0 0.9
vin gate 0 pulse 0 0.9 1ns 1ns 1ns 3ns 8ns

Xn out gate 0 0 nfet L=20n NFIN=1
Xp out gate vdd vdd pfet L=20n NFIN=1

.options post=2 nomod
.op
.dc vin 0 0.9 0.05

.END

