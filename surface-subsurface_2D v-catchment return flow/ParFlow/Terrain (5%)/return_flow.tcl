#  This runs the tilted-v catchment problem
#  return flow

set runname return_flow

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

pfset ComputationalGrid.NX                80
pfset ComputationalGrid.NY                1
pfset ComputationalGrid.NZ                100

pfset ComputationalGrid.DX	         5.0
pfset ComputationalGrid.DY               5.0
pfset ComputationalGrid.DZ	         0.05
#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------
pfset GeomInput.Names                 "domaininput"
pfset GeomInput.domaininput.GeomName  domain
pfset GeomInput.domaininput.InputType  Box 

#---------------------------------------------------------
# Domain Geometry 
#---------------------------------------------------------
pfset Geom.domain.Lower.X                        0.0
pfset Geom.domain.Lower.Y                        0.0
pfset Geom.domain.Lower.Z                        0.0
 
pfset Geom.domain.Upper.X                        400.0
pfset Geom.domain.Upper.Y                        5.0
pfset Geom.domain.Upper.Z                        5.0
pfset Geom.domain.Patches             "x-lower x-upper y-lower y-upper z-lower z-upper"

#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------
pfset Geom.Perm.Names                 "domain"

# Values in m/minute

pfset Geom.domain.Perm.Type            Constant
pfset Geom.domain.Perm.Value         	 6.94e-2

pfset Perm.TensorType               TensorByGeom

pfset Geom.Perm.TensorByGeom.Names  "domain"
pfset Geom.domain.Perm.TensorValX  1.0
pfset Geom.domain.Perm.TensorValY  1.0
pfset Geom.domain.Perm.TensorValZ  1.0

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
pfset TimingInfo.BaseUnit        1.0
pfset TimingInfo.StartCount      0
pfset TimingInfo.StartTime       0.0
pfset TimingInfo.StopTime        400.0
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
# rain for 200 mins, recession for 200 mins

pfset Cycle.rainrec.Names                 "rain rec"
pfset Cycle.rainrec.rain.Length           200
pfset Cycle.rainrec.rec.Length            200
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

## overland flow boundary condition
# Values in m/minute
pfset Patch.z-upper.BCPressure.Type		      OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		      "rainrec"
pfset Patch.z-upper.BCPressure.rain.Value	      -1.5e-4
pfset Patch.z-upper.BCPressure.rec.Value	       5.4e-6

#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------
pfset TopoSlopesX.Type "Constant"
pfset TopoSlopesX.GeomNames "domain"
pfset TopoSlopesX.Geom.domain.Value 	-0.05

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------
pfset TopoSlopesY.Type "Constant"
pfset TopoSlopesY.GeomNames "domain"
pfset TopoSlopesY.Geom.domain.Value 	0.0

#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------
pfset Mannings.Type "Constant"
pfset Mannings.GeomNames "domain"
pfset Mannings.Geom.domain.Value 	3.31e-4

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
pfset Solver.Drop                                       1E-20
pfset Solver.AbsTol                                     1E-12
 
pfset Solver.PrintPressure                  True
pfset Solver.PrintSaturation                True
pfset Solver.PrintMask                      False
pfset Solver.PrintSubsurf                   True
pfset Solver.PrintSpecificStorage           False
pfset Solver.PrintVelocities                False
pfset Solver.PrintConcentration             True
pfset Solver.PrintWells                     True
pfset Solver.PrintLSMSink                   False
 
pfset Solver.WriteSiloSubsurfData True
#pfset Solver.WriteSiloPressure True
#pfset Solver.WriteSiloSaturation True
#pfset Solver.WriteSiloConcentration True
pfset Solver.WriteSiloMask True
pfset Solver.WriteSiloSlopes True
pfset Solver.WriteSiloMannings True
pfset Solver.WriteSiloSpecificStorage True

#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------
pfset ICPressure.Type                                   HydroStaticPatch
pfset ICPressure.GeomNames                              domain
pfset Geom.domain.ICPressure.Value                      -0.5

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
set specific_storage [pfload $runname.out.specific_storage.silo]
set porosity         [pfload $runname.out.porosity.silo]
set top              [pfcomputetop $mask]

set total_time [pfget TimingInfo.StopTime]

set fileId_1 [open total_out_flow.txt w 0600]
set fileId_2 [open surface_storage.txt w 0600]
set fileId_3 [open subsurface_storage.txt w 0600]

for {set k 0} {$k <= $total_time} {incr k 1} {
if {$k < 10} {
set pressure [pfload $runname.out.press.0000$k.pfb]
set saturation [pfload $runname.out.satur.0000$k.pfb] }
if {$k > 9 } {
if {$k > 99} { 
set pressure [pfload $runname.out.press.00$k.pfb] 
set saturation [pfload $runname.out.satur.00$k.pfb] 
} else {
set pressure [pfload $runname.out.press.000$k.pfb] 
set saturation [pfload $runname.out.satur.000$k.pfb] }
}

# surface_runoff
set surface_runoff [pfsurfacerunoff $top $slope_x $slope_y $mannings $pressure]
set total_surface_runoff [expr [pfsum $surface_runoff] * [pfget TimeStep.Value]]
puts $fileId_1 "$k  $total_surface_runoff"

# surface_storage
set surface_storage [pfsurfacestorage $top $pressure]
set total_surface_storage [pfsum $surface_storage]
puts $fileId_2 "$k  $total_surface_storage"

# subsurface_storage
set subsurface_storage [pfsubsurfacestorage $mask $porosity \
$pressure $saturation $specific_storage]
set total_subsurface_storage [pfsum $subsurface_storage]
puts $fileId_3 "$k  $total_subsurface_storage"

# water_table_depth
set water_table_depth [pfwatertabledepth $top $saturation]
if {$k < 10} {pfsave $water_table_depth -pfb "water_table_depth.0000$k.pfb"}
if {$k > 9 } {
if {$k > 99} {pfsave $water_table_depth -pfb "water_table_depth.00$k.pfb"
} else {pfsave $water_table_depth -pfb "water_table_depth.000$k.pfb"}
}

}

close $fileId_1
close $fileId_2
close $fileId_3

