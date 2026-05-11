* SProcess through SWB
* Combined NMOS and PMOS - BICMOS5 EKL Device IdVd
* ET4ICP

** #########################################################################
** #################### Variables based on deviceType ######################

##### Device is PMOS #####


** #########################################################################
** ############################# File Section ##############################

File {
	* Input Files
	Grid= "n25_dev_fps.tdr"
}

** #########################################################################
** ########################## Electrode Section ############################

	Electrode {
		{ Name="source"    Voltage= 0.0 }
		{ Name="drain"     Voltage= 0.0 }
		{ Name="gate"      Voltage= 0.0 }
		{ Name="substrate" Voltage= 0.0 }
		{ Name="psubstrate" Voltage= 0.0 }
	}

** #########################################################################
** ############################# Math Section ##############################

Math {
	Extrapolate
	ExitOnFailure
	Iterations= 20
}

** #########################################################################
** ############################# Plot Section ##############################

Plot{
   TotalCurrent
}

** #########################################################################
** ########################### Physics Section #############################

* ##### Physics - Trapped Interface Charge #####
Physics ( MaterialInterface= "Oxide/Silicon" ) {
	Traps ( 
		( FixedCharge Conc= -2e10 )
	)
}

* ##### Physics - Initial Solve #####
	Physics {
		Recombination ( SRH ( DopingDependence ) Auger )
		EffectiveIntrinsicDensity( BandGapNarrowing ( OldSlotboom ) )
	}

** #########################################################################
** ############################ Solve Section ##############################

* ##### Initial Solve - Gummel #####
Solve {
	Plugin (Iterations = 100) { Poisson }
}

** #########################################################################
** ########################### Physics Section #############################

* ##### Physics - Subsequent solve #####
	Physics {
		Recombination ( SRH ( DopingDependence ) Auger )
		EffectiveIntrinsicDensity( BandGapNarrowing ( OldSlotboom ) )
		Mobility ( Enormal ( UniBo ) )
	}

** #########################################################################
** ############################ Solve Section ##############################

* ##### Subsequent solve #####
Solve {
	Coupled { Poisson Electron Hole }


######## Gate ramp  ########


# --- Vg ramp 0V to -0.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -0.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_0")

# --- Vg ramp 0V to -1.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -1.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-1")

# --- Vg ramp 0V to -2.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -2.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-2")

# --- Vg ramp 0V to -3.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -3.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-3")

# --- Vg ramp 0V to -4.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -4.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-4")

# --- Vg ramp 0V to -5.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -5.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-5")

# --- Vg ramp 0V to -6.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -6.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-6")

# --- Vg ramp 0V to -7.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = gate  Voltage = -7.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n33_PMOS_9e11_gateBias_-7")

######## IdVd Ramp ########


# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_0")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_0_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-1")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-1_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-2")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-2_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-3")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-3_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-4")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-4_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-5")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-5_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-6")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-6_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vd ramp = 0V to -5.0 --- #

Load(FilePreFix="n33_PMOS_9e11_gateBias_-7")
NewCurrentPrefix="n33_PMOS_9e11_IdVd_gateBias_-7_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = drain Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }


}

** ################################# EOF ###################################
** #########################################################################


