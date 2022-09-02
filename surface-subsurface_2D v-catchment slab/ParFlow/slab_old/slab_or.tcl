#  This runs the tilted-v catchment problem
#  slab

set runname slab

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

pfset ComputationalGrid.NX                40
pfset ComputationalGrid.NY                1
pfset ComputationalGrid.NZ                104

pfset ComputationalGrid.DX	          10.0
pfset ComputationalGrid.DY                10.0
pfset ComputationalGrid.DZ	          0.05
#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------
#pfset GeomInput.Names                 "domaininput slabinput"
#pfset GeomInput.domaininput.GeomName  domain
#pfset GeomInput.domaininput.InputType  Box 
#pfset GeomInput.slabinput.GeomName  slab
#pfset GeomInput.slabinput.InputType  Box

pfset GeomInput.Names                 "domaininput slabinput"
pfset GeomInput.domaininput.GeomNames  domain
pfset GeomInput.domaininput.InputType  SolidFile
pfset GeomInput.domaininput.FileName   domain_grid.pfsol

pfset GeomInput.slabinput.GeomNames  slab
pfset GeomInput.slabinput.InputType  SolidFile
pfset GeomInput.slabinput.FileName   slab_grid.pfsol

#---------------------------------------------------------
# Domain Geometry 
#---------------------------------------------------------
#pfset Geom.domain.Lower.X                        0.0
#pfset Geom.domain.Lower.Y                        0.0
#pfset Geom.domain.Lower.Z                        0.0 
#pfset Geom.domain.Upper.X                        400.0
#pfset Geom.domain.Upper.Y                        10.0
#pfset Geom.domain.Upper.Z                        5.0

pfset Geom.domain.Patches             "x-lower x-upper y-lower y-upper z-lower z-upper"

#---------------------------------------------------------
# Slab Geometry 
#---------------------------------------------------------
#pfset Geom.slab.Lower.X                        150.0
#pfset Geom.slab.Lower.Y                        0.0
#pfset Geom.slab.Lower.Z                        4.95
 
#pfset Geom.slab.Upper.X                        250.0
#pfset Geom.slab.Upper.Y                        10.0
#pfset Geom.slab.Upper.Z                        5.0
pfset Geom.slab.Patches             "slab-x-lower slab-x-upper slab-y-lower slab-y-upper slab-z-lower slab-z-upper"

#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------
pfset Geom.Perm.Names                 "domain slab"

# Values in m/minute

pfset Geom.domain.Perm.Type            Constant
pfset Geom.domain.Perm.Value         	 6.9e-04

pfset Geom.slab.Perm.Type            Constant
pfset Geom.slab.Perm.Value         	 6.9e-06

pfset Perm.TensorType               TensorByGeom

pfset Geom.Perm.TensorByGeom.Names  "domain"
pfset Geom.domain.Perm.TensorValX  1.0
pfset Geom.domain.Perm.TensorValY  1.0
pfset Geom.domain.Perm.TensorValZ  1.0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------
pfset SpecificStorage.Type               Constant
pfset SpecificStorage.GeomNames          "domain"
pfset Geom.domain.SpecificStorage.Value   5.0e-4

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
pfset TimingInfo.BaseUnit        1.0
pfset TimingInfo.StartCount      0
pfset TimingInfo.StartTime       0.0
pfset TimingInfo.StopTime        300.0
pfset TimingInfo.DumpInterval    -1
pfset TimeStep.Type              Constant
pfset TimeStep.Value             1.0
 
#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------
pfset Geom.Porosity.GeomNames          "domain"
pfset Geom.domain.Porosity.Type          Constant
pfset Geom.domain.Porosity.Value         0.4

#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------
pfset Domain.GeomName domain
#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------
pfset Phase.RelPerm.Type               VanGenuchten
pfset Phase.RelPerm.GeomNames          "domain"

pfset Geom.domain.RelPerm.Alpha         1.0
pfset Geom.domain.RelPerm.N             2.0

#---------------------------------------------------------
# Saturation
#---------------------------------------------------------
pfset Phase.Saturation.Type              VanGenuchten
pfset Phase.Saturation.GeomNames         "domain"

pfset Geom.domain.Saturation.Alpha        1.0
pfset Geom.domain.Saturation.N            2.0
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
# rain for 200 mins, recession for 100 mins

pfset Cycle.rainrec.Names                 "rain rec"
pfset Cycle.rainrec.rain.Length           200
pfset Cycle.rainrec.rec.Length            100
pfset Cycle.rainrec.Repeat                -1
 
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
# Values in m/minute
pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		      "rainrec"
pfset Patch.z-upper.BCPressure.rain.Value	      -3.3e-4
pfset Patch.z-upper.BCPressure.rec.Value	      0.0

#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------
pfset TopoSlopesX.Type "Constant"
pfset TopoSlopesX.GeomNames "domain"
pfset TopoSlopesX.Geom.domain.Value -0.0005

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------
pfset TopoSlopesY.Type "Constant"
pfset TopoSlopesY.GeomNames "domain"
pfset TopoSlopesY.Geom.domain.Value 0.0

#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------
pfset Mannings.Type "Constant"
pfset Mannings.GeomNames "domain"
pfset Mannings.Geom.domain.Value 3.31e-4

#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------
pfset PhaseSources.water.Type                         Constant
pfset PhaseSources.water.GeomNames                    domain
pfset PhaseSources.water.Geom.domain.Value              0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------
pfset KnownSolution                                    NoKnownSolution
#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------
pfset Solver.TerrainFollowingGrid                        False

pfset Solver                                             Richards
pfset Solver.MaxIter                                     300
pfset Solver.AbsTol                                      1E-12

#pfset Solver.Linear.Preconditioner                       PFMG 
pfset Solver.Linear.Preconditioner                       MGSemi
pfset Solver.Linear.Preconditioner.MGSemi.MaxIter        1
pfset Solver.Linear.Preconditioner.MGSemi.MaxLevels      10
pfset Solver.Linear.KrylovDimension                      25
pfset Solver.Linear.MaxRestart                           2

pfset Solver.Nonlinear.MaxIter                           300
pfset Solver.Nonlinear.ResidualTol                       1e-12
pfset Solver.Nonlinear.StepTol				 1e-30
pfset Solver.Nonlinear.EtaChoice                         Walker1 
#pfset Solver.Nonlinear.EtaChoice                         EtaConstant
#pfset Solver.Nonlinear.EtaValue                          0.001
pfset Solver.Nonlinear.UseJacobian                       False
pfset Solver.Nonlinear.DerivativeEpsilon                 1e-15


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
pfset Geom.domain.ICPressure.Value                      -1.0

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

set fileId_1 [open total_out_flow.txt w 0600]
set fileId_2 [open overland_flow.txt w 0600]


for {set k 0} {$k <= 300} {incr k 1} {
if {$k < 10} {
set press [pfload $runname.out.press.0000$k.pfb] }
if {$k > 9 } {
if {$k > 99} { 
set press [pfload $runname.out.press.00$k.pfb]
} else {
set press [pfload $runname.out.press.000$k.pfb] }
}

#set outp [pfgetelt $press 399 0 99]

# surface_runoff
set surface_runoff [pfsurfacerunoff $top $slope_x $slope_y $mannings $press]
set total_surface_runoff [expr [pfsum $surface_runoff] * [pfget TimeStep.Value]]
puts $fileId_1 "$k $total_surface_runoff"

# overland flow
set P [pfgetelt $press 39 0 99]
set sx [pfgetelt $slope_x 39 0 0]
set sy [pfgetelt $slope_y 39 0 0]
set S [expr ($sx**2+$sy**2)**0.5]
set n [pfget Mannings.Geom.domain.Value]
if {$P < 0} {set P 0}
set dx [pfget ComputationalGrid.DX]
set QT [expr ($dx/$n)*($S**0.5)*($P**(5./3.))]
#puts $fileId_2 "$k $QT"

}
close $fileId_1
close $fileId_2

