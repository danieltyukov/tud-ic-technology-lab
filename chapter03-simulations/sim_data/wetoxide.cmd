## **************************************************************************
## *********************  GRID DEFINITION ***********************************

line x loc=-1.0<um> spacing=1<nm>
line x loc=0<um> spacing=1<nm> tag=left	
line x loc=1.0<um> spacing=1<nm> tag=right

## **************************************************************************
## ********************** STARTING MATERIAL *********************************

region Silicon xlo=left xhi=right

init concentration=1e+16<cm-3> field=Boron

AdvancedCalibration

## *************************************************************************
## ********************** IMPLANTATION *************************************

implant Arsenic dose=5e15 energy=40 tilt=7 rotation=22

## **************************************************************************
## ************************ GATE OXIDE & ANNEAL *****************************

set siliconClusterModel [pdbGet Silicon Int ClusterModel]
puts "Silicon Cluster Model : ${siliconClusterModel}"
pdbSet Silicon Int ClusterModel Full
puts "Silicon Cluster Model : ${siliconClusterModel}"

pdbSetBoolean Oxide_Silicon O2 DopantDependentReaction 1
pdbSetBoolean Oxide_Silicon H2O DopantDependentReaction 1

temp_ramp clear
temp_ramp name=gateoxide time=30 flows= {N2= 6.0<l/min>} temperature= 600

temp_ramp name=gateoxide time=40 flows= {N2= 3.0<l/min>} t.final= 1000
temp_ramp name=gateoxide time=2 flows= {N2= 3.0<l/min>} temperature= 1000

temp_ramp name=gateoxide time=9 flows= {H2= 3.85<l/min> O2=2.25<l/min>} temperature= 1000
temp_ramp name=gateoxide flows= {N2= 3<l/min>} temperature= 1000 ramprate=-7<K/min> t.final= 580
temp_ramp name=gateoxide time=5 flows= {N2= 3.0<l/min>} temperature= 580

diffuse temp.ramp= gateoxide

## *************************************************************************
## ********************* PLOTTING ******************************************

select z=log10(Arsenic)
plot.1d boundary
plot.1d !clear color=blue title="Implantation" label="Arsenic" min = {-1 15} max = {1 20}


## ************************************************************************
## Export data to CSVs

print.data outfile=wetoxide-As.out name=Arsenic
