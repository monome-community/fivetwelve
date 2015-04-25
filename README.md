# fivetwelve

a collection of information regarding the five twelve, a special edition produced in april of 2010.

## settings


with cables oriented towards the left, the 512 is two 256's side by side. the one on the left has a serial number of m256-?-0 and the right m256-?-1 where ? is your unique id. (yes, there are only 10!)

### serialosc setup


The 512 appears as a pair of 256 monome grids. serialosc applications for the 512 address each 256 grid as a separate device.

### monome serial setup


you edit the left and right half by accessing the dropdown in monomeserial.

to create a mapped 32x16 grid in monomeserial set both to cable left, unit-0 to offset 0,0 and unit-1 to offset 16 columns 0 rows.

to create a mapped 16x32 grid (with cables coming out the top) set both to cable top, unit-0 offset 0,0 and unit-1 offset 0 cols 16 rows.

## applications


included in this repo (click `download zip`):
- mlr 31 rows
- mlr 32 steps
- 512life

additionally, these two stretta applications support the 512 grid:
- (straw)[https://github.com/monome-community/straw]
- (plane)[https://github.com/monome-community/plane]