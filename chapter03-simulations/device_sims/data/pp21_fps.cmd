

math coord.ucs

math numThreads= 4


puts " *** Checking Parameter Values *** "
set siliconDiffModel [pdbGet Silicon Dopant DiffModel]
puts "Silicon Diffusion Model : ${siliconDiffModel}"
set computeNoStressRelax [pdbGet Compute NoStressRelax]
puts "Compute NoStressRelax : ${computeNoStressRelax}"
set mechanicsSaveElasticStrain [pdbGet Mechanics saveElasticStrain]
puts "Mechanics SaveElasticStrain : ${mechanicsSaveElasticStrain}"
set mechanicsDecomposeStress [pdbGet Mechanics decomposeStress]
puts "Mechanics DecomposeStress : ${mechanicsDecomposeStress}"
set implantResistSkip [pdbGet Implant ResistSkip]
puts "Implant ResistSkip : ${implantResistSkip}"

pdbSet InfoDefault 0

pdbSet Silicon Dopant DiffModel Fermi
pdbSet Implant ResistSkip 1


puts " *** Post Setting Parameter Values *** "
set siliconDiffModel [pdbGet Silicon Dopant DiffModel]
puts "Silicon Diffusion Model : ${siliconDiffModel}"
set computeNoStressRelax [pdbGet Compute NoStressRelax]
puts "Compute NoStressRelax : ${computeNoStressRelax}"
set mechanicsSaveElasticStrain [pdbGet Mechanics saveElasticStrain]
puts "Mechanics SaveElasticStrain : ${mechanicsSaveElasticStrain}"
set mechanicsDecomposeStress [pdbGet Mechanics decomposeStress]
puts "Mechanics DecomposeStress : ${mechanicsDecomposeStress}"
set implantResistSkip [pdbGet Implant ResistSkip]
puts "Implant ResistSkip : ${implantResistSkip}"


set devicetype PMOS

set vtadj 9e11
set vtadjenergy 25

if {$devicetype == "NMOS"} {
	set xMin 0.0
	set xMax 5.0
	set yMin 0.0
	set yMax 50.0
} elseif {$devicetype == "PMOS"} {
	set xMin 0.0
	set xMax 5.0
	set yMin 0.0
	set yMax 50.0
}


if {$devicetype == "NMOS"} {
	mask name= co segments= {${yMin} 11.0 14.0 30.0 35.0 ${yMax}}
	mask name= al segments= {10.0 15.0 29.0 36.0 44.5 ${yMax}}
} elseif {$devicetype == "PMOS"} {
	mask name= co segments= {${yMin} 6.0 9.0 19.0 21.0 30.0 35.0 ${yMax}}
	mask name= al segments= {6.0 9.0 19.0 21.0 30.0 35.0 44.5 ${yMax}}
}


set siliconClusterModel [pdbGet Silicon Int ClusterModel]
puts "Silicon Cluster Model : ${siliconClusterModel}"
pdbSet Silicon Int ClusterModel Full
puts "Silicon Cluster Model : ${siliconClusterModel}"

init tdr= n15


implant Boron dose= ${vtadj} energy= ${vtadjenergy} tilt=7 rotation=22

etch oxide etchstop= Silicon

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


etch oxide mask= co type= anisotropic rate= 1.3<nm/s> time= 156<s> temperature= 20


deposit Aluminum thickness=1<um>

etch Aluminum mask= al type=anisotropic etchstop= oxide


transform reflect right


struct tdr=n21

