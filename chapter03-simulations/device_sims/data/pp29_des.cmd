* SProcess through SWB
* Combined NMOS and PMOS - BICMOS5 EKL Device IdVg
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
		{ Name="source"    	Voltage= 0.0 }
		{ Name="drain"     	Voltage= 0.0 }
		{ Name="gate"      	Voltage= 0.0 }
		{ Name="substrate" 	Voltage= 0.0 }
		{ Name="psubstrate" Voltage= 0.0 }
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
		EffectiveIntrinsicDensity( OldSlotboom )
		Mobility ( Enormal ( UniBo ) )
	}

** #########################################################################
** ############################ Solve Section ##############################

* ##### Subsequent solve #####
Solve {
	Coupled { Poisson Electron Hole }
	

######## Drain ramp  ########


# --- Vd ramp = 0V to -0.1 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = drain  Voltage = -0.1 }
) { Coupled { Poisson Electron Hole  } }

######## Substrate ramp  ########


# --- Vsub ramp = 0V to 0.0 --- #

Quasistationary (
InitialStep = 1e-4
Minstep     = 1e-5
MaxStep     = 0.1
Goal { name = substrate  Voltage = 0.0 }
) { Coupled { Poisson Electron Hole  } }
save(FilePrefix="n29_PMOS_9e11_subBias_0")

######## IdVg Ramp ########


# --- Vg ramp = 0 to -5.0 --- #

Load(FilePreFix="n29_PMOS_9e11_subBias_0")
NewCurrentPrefix="n29_PMOS_9e11_IdVg_subBias_0_"
Quasistationary (
InitialStep = 1e-2
Minstep     = 1e-5
MaxStep     = 0.05
Goal { name = gate Voltage = -5.0}
) { Coupled { Poisson Electron Hole } }


}

** ################################# EOF ###################################
** #########################################################################


