* SProcess through SWB
* Combined NMOS and PMOS - BICMOS5 EKL Device IdVg
* ET4ICP

** #########################################################################
** #################### Variables based on deviceType ######################

##### Device is NMOS #####


** #########################################################################
** ############################# File Section ##############################

File {
	* Input Files
	Grid= "n24_dev_fps.tdr"
}

** #########################################################################
** ########################## Electrode Section ############################

	Electrode {
		{ Name="source"    Voltage= 0.0 }
		{ Name="drain"     Voltage= 0.0 }
		{ Name="gate"      Voltage= 0.0 }
		{ Name="substrate" Voltage= 0.0 }
	} 

** #########################################################################
** ############################# Math Section ##############################

Math {
	Extrapolate
	ExitOnFailure
	Iterations= 45
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
		( FixedCharge Conc= 1e11 )
	)
}

* ##### Physics - Initial Solve #####
	Physics {
		Recombination ( SRH ( DopingDependence ) Auger )
		EffectiveIntrinsicDensity( OldSlotboom )
		Mobility ( HighFieldSaturation ( Eparallel ) DopingDependence )
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
		EffectiveIntrinsicDensity( OldSlotboom )
		Mobility ( Enormal ( UniBo ) )
	}

** #########################################################################
** ############################ Solve Section ##############################

* ##### Subsequent solve #####
Solve {
	Coupled { Poisson Electron Hole }
	

######## Drain ramp  ########


# --- Vd ramp = 0V to 0.1 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = drain  Voltage = 0.1 }
) { Coupled { Poisson Electron Hole  } }

######## Substrate ramp  ########


# --- Vsub ramp = 0V to -0.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = substrate  Voltage = -0.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n28_NMOS_9e11_subBias_0")

# --- Vsub ramp = 0V to -1.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = substrate  Voltage = -1.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n28_NMOS_9e11_subBias_-1")

# --- Vsub ramp = 0V to -2.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = substrate  Voltage = -2.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n28_NMOS_9e11_subBias_-2")

######## IdVg Ramp ########


# --- Vg ramp = 0 to 5.0 --- #

Load(FilePreFix="n28_NMOS_9e11_subBias_0")
NewCurrentPrefix="n28_NMOS_9e11_IdVg_subBias_0_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = gate Voltage = 5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vg ramp = 0 to 5.0 --- #

Load(FilePreFix="n28_NMOS_9e11_subBias_-1")
NewCurrentPrefix="n28_NMOS_9e11_IdVg_subBias_-1_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = gate Voltage = 5.0}
) { Coupled { Poisson Electron Hole } }

# --- Vg ramp = 0 to 5.0 --- #

Load(FilePreFix="n28_NMOS_9e11_subBias_-2")
NewCurrentPrefix="n28_NMOS_9e11_IdVg_subBias_-2_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = gate Voltage = 5.0}
) { Coupled { Poisson Electron Hole } }


}

** ################################# EOF ###################################
** #########################################################################


