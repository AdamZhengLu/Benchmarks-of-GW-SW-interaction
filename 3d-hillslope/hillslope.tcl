#  This runs the 3D Hillslope problem
#  similar to that in Weill et al. (2009) JH

set runname hillslope

#
# Import the ParFlow TCL package
#
lappend auto_path $env(PARFLOW_DIR)/bin 
package require parflow
namespace import Parflow::*

pfset FileVersion 4

pfset Process.Topology.P 1
pfset Process.Topology.Q 1
pfset Process.Topology.R 1

#---------------------------------------------------------
# Computational Grid
#---------------------------------------------------------
pfset ComputationalGrid.Lower.X           0.0
pfset ComputationalGrid.Lower.Y           0.0
pfset ComputationalGrid.Lower.Z           0.0

pfset ComputationalGrid.NX                1
pfset ComputationalGrid.NY                35
pfset ComputationalGrid.NZ                120

pfset ComputationalGrid.DX	             0.08
pfset ComputationalGrid.DY               0.04
pfset ComputationalGrid.DZ	             0.01
#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------
pfset GeomInput.Names                 "domaininput upinput downinput"

pfset GeomInput.domaininput.GeomName  domain
pfset GeomInput.upinput.GeomName  up
pfset GeomInput.downinput.GeomName  down

pfset GeomInput.domaininput.InputType  Box 
pfset GeomInput.upinput.InputType  Box 
pfset GeomInput.downinput.InputType  Box 

#---------------------------------------------------------
# Domain Geometry 
#---------------------------------------------------------
pfset Geom.domain.Lower.X                        0.0
pfset Geom.domain.Lower.Y                        0.0
pfset Geom.domain.Lower.Z                        0.0
 
pfset Geom.domain.Upper.X                        0.08
pfset Geom.domain.Upper.Y                        1.40
pfset Geom.domain.Upper.Z                        1.20
pfset Geom.domain.Patches             "x-lower x-upper y-lower y-upper z-lower z-upper"

#---------------------------------------------------------
# up Slope Geometry 
#---------------------------------------------------------
pfset Geom.up.Lower.X                        0.0
pfset Geom.up.Lower.Y                        0.0
pfset Geom.up.Lower.Z                        0.76
 
pfset Geom.up.Upper.X                        0.08
pfset Geom.up.Upper.Y                        1.40
pfset Geom.up.Upper.Z                        1.20

#---------------------------------------------------------
# down Slope Geometry 
#---------------------------------------------------------

pfset Geom.down.Lower.X                        0.0
pfset Geom.down.Lower.Y                        0.0
pfset Geom.down.Lower.Z                        0.0
 
pfset Geom.down.Upper.X                        0.08
pfset Geom.down.Upper.Y                        1.40
pfset Geom.down.Upper.Z                        0.76

#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------

pfset Geom.Perm.Names                 "up down"

# Values in m/s

pfset Geom.up.Perm.Type            Constant
pfset Geom.up.Perm.Value         	 3.5d-5

pfset Geom.down.Perm.Type            Constant
pfset Geom.down.Perm.Value            3.5d-5

pfset Perm.TensorType               TensorByGeom

pfset Geom.Perm.TensorByGeom.Names  "domain"

pfset Geom.domain.Perm.TensorValX  1.0d0
pfset Geom.domain.Perm.TensorValY  1.0d0
pfset Geom.domain.Perm.TensorValZ  1.0d0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type            Constant
pfset SpecificStorage.GeomNames       "domain"
pfset Geom.domain.SpecificStorage.Value 0.0005

#-----------------------------------------------------------------------------
# Phases
#-----------------------------------------------------------------------------

pfset Phase.Names "water"

pfset Phase.water.Density.Type	        Constant
pfset Phase.water.Density.Value	        1.0

pfset Phase.water.Viscosity.Type	Constant
pfset Phase.water.Viscosity.Value	1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------

pfset Contaminants.Names			""

#-----------------------------------------------------------------------------
# Retardation
#-----------------------------------------------------------------------------

pfset Geom.Retardation.GeomNames           ""

#-----------------------------------------------------------------------------
# Gravity
#-----------------------------------------------------------------------------

pfset Gravity				1.0

#-----------------------------------------------------------------------------
# Setup timing info
#-----------------------------------------------------------------------------

# 
pfset TimingInfo.BaseUnit        1.0
pfset TimingInfo.StartCount      0
pfset TimingInfo.StartTime       0.0
pfset TimingInfo.StopTime        1500.0
pfset TimingInfo.DumpInterval    -1
pfset TimeStep.Type              Constant
pfset TimeStep.Value             10.0
 
#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------

pfset Geom.Porosity.GeomNames          "up down channel"

pfset Geom.up.Porosity.Type          Constant
pfset Geom.up.Porosity.Value         0.34

pfset Geom.down.Porosity.Type          Constant
pfset Geom.down.Porosity.Value         0.34

#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------

pfset Domain.GeomName domain

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------

pfset Phase.RelPerm.Type               VanGenuchten
pfset Phase.RelPerm.GeomNames          "domain"

pfset Geom.domain.RelPerm.Alpha         2.3
pfset Geom.domain.RelPerm.N             5.5

#---------------------------------------------------------
# Saturation
#---------------------------------------------------------

pfset Phase.Saturation.Type              VanGenuchten
pfset Phase.Saturation.GeomNames         "domain"

pfset Geom.domain.Saturation.Alpha        2.3
pfset Geom.domain.Saturation.N            5.5
pfset Geom.domain.Saturation.SRes         0.2
pfset Geom.domain.Saturation.SSat         1.0

#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names                           ""

#-----------------------------------------------------------------------------
# Time Cycles
#-----------------------------------------------------------------------------
pfset Cycle.Names "constant rainrec"
pfset Cycle.constant.Names              "alltime"
pfset Cycle.constant.alltime.Length      1
pfset Cycle.constant.Repeat             -1

# rainfall and recession time periods are defined here
# rain for 20 mins, recession for 5 mins

pfset Cycle.rainrec.Names                 "rain rec"
pfset Cycle.rainrec.rain.Length           1200
pfset Cycle.rainrec.rec.Length            300
pfset Cycle.rainrec.Repeat                0 
 
#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------
pfset BCPressure.PatchNames                   [pfget Geom.domain.Patches]

pfset Patch.x-lower.BCPressure.Type		      FluxConst
pfset Patch.x-lower.BCPressure.Cycle		      "constant"
pfset Patch.x-lower.BCPressure.alltime.Value	      0.0

pfset Patch.y-lower.BCPressure.Type		      FluxConst
pfset Patch.y-lower.BCPressure.Cycle		      "constant"
pfset Patch.y-lower.BCPressure.alltime.Value	      0.0

pfset Patch.z-lower.BCPressure.Type		      FluxConst
pfset Patch.z-lower.BCPressure.Cycle		      "constant"
pfset Patch.z-lower.BCPressure.alltime.Value	      0.0

pfset Patch.x-upper.BCPressure.Type		      FluxConst
pfset Patch.x-upper.BCPressure.Cycle		      "constant"
pfset Patch.x-upper.BCPressure.alltime.Value	      0.0

pfset Patch.y-upper.BCPressure.Type		      FluxConst
pfset Patch.y-upper.BCPressure.Cycle		      "constant"
pfset Patch.y-upper.BCPressure.alltime.Value	      0.0

## overland flow boundary condition with very heavy rainfall 
pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		      "rainrec"
pfset Patch.z-upper.BCPressure.rain.Value	      -1.2d-5
pfset Patch.z-upper.BCPressure.rec.Value	      0.0

#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------

pfset TopoSlopesX.Type "Constant"
pfset TopoSlopesX.GeomNames "up down channel"
pfset TopoSlopesX.Geom.up.Value 	0.00
pfset TopoSlopesX.Geom.down.Value 	0.00

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------

pfset TopoSlopesY.Type "Constant"
pfset TopoSlopesY.GeomNames "up down channel"
pfset TopoSlopesY.Geom.up.Value 	-0.3143
pfset TopoSlopesY.Geom.down.Value	0.00

#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------

pfset Mannings.Type "Constant"
pfset Mannings.GeomNames "up down channel"
pfset Mannings.Geom.up.Value 		0.185
pfset Mannings.Geom.down.Value 	0.185

#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------

pfset PhaseSources.water.Type                         Constant
pfset PhaseSources.water.GeomNames                    domain
pfset PhaseSources.water.Geom.domain.Value        0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                                    NoKnownSolution


#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------

pfset Solver                                             Richards
pfset Solver.MaxIter                                     2500

pfset Solver.Nonlinear.MaxIter                           300
pfset Solver.Nonlinear.ResidualTol                       1e-12
pfset Solver.Nonlinear.EtaChoice                         Walker1 
pfset Solver.Nonlinear.EtaChoice                         EtaConstant
pfset Solver.Nonlinear.EtaValue                          0.001
pfset Solver.Nonlinear.UseJacobian                       False
pfset Solver.Nonlinear.DerivativeEpsilon                 1e-16
pfset Solver.Nonlinear.StepTol				 1e-30
pfset Solver.Nonlinear.Globalization                     LineSearch
pfset Solver.Linear.KrylovDimension                      20
pfset Solver.Linear.MaxRestart                           2

pfset Solver.Linear.Preconditioner                       MGSemi
pfset Solver.Linear.Preconditioner.MGSemi.MaxIter        1
pfset Solver.Linear.Preconditioner.MGSemi.MaxLevels      10
pfset  Solver.Drop                                      1E-20
pfset Solver.AbsTol                                     1E-12
 
#pfset Solver.PrintPressure                  False
pfset Solver.PrintSaturation                False
#pfset Solver.PrintMask                      False
pfset Solver.PrintSubsurf                   False
pfset Solver.PrintVelocities                False
pfset Solver.PrintConcentration             False
pfset Solver.PrintWells                     False
pfset Solver.PrintLSMSink                   False
 
#pfset Solver.WriteSiloSubsurfData True
#pfset Solver.WriteSiloPressure True
#pfset Solver.WriteSiloSaturation True
#pfset Solver.WriteSiloConcentration True
pfset Solver.WriteSiloMask True
pfset Solver.WriteSiloSlopes True
pfset Solver.WriteSiloMannings True

#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

pfset ICPressure.Type                                   HydroStaticPatch
pfset ICPressure.GeomNames                              domain
pfset Geom.domain.ICPressure.Value                      -0.44

pfset Geom.domain.ICPressure.RefGeom                    domain
pfset Geom.domain.ICPressure.RefPatch                   z-upper

#-----------------------------------------------------------------------------
# Run and Unload the ParFlow output files
#-----------------------------------------------------------------------------

pfrun $runname
pfundist $runname
set slope_x          [pfload $runname.out.slope_x.silo]
set slope_y          [pfload $runname.out.slope_y.silo]
set mannings         [pfload $runname.out.mannings.silo]
set mask             [pfload $runname.out.mask.silo]
set top              [pfcomputetop $mask]

set fileId [open outflow.txt w 0600]
for {set k 0} {$k <= 180} {incr k 1} {
if {$k < 10} {
set press [pfload $runname.out.press.0000$k.pfb] }
if {$k > 9 } {
if {$k > 99} { 
set press [pfload $runname.out.press.00$k.pfb] 
} else {
set press [pfload $runname.out.press.000$k.pfb] }
}

set outp1 [pfgetelt $press 0 34 75]

set surface_runoff [pfsurfacerunoff $top $slope_x $slope_y $mannings $press]
	set total_surface_runoff [expr [pfsum $surface_runoff] * [pfget TimeStep.Value]]
	puts [format "$k %.16e" $total_surface_runoff]


puts $fileId "$k $outp1"
}
close $fileId



