using LinearAlgebra
using SharedArrays
using Zygote
## ========INCLUDE PACKAGES=========
using Dates, BenchmarkTools, DelimitedFiles, Printf
using CSV, DataFrames
using StaticArrays, Statistics, SparseArrays
using Kronecker, NearestNeighbors, LazyGrids
using Makie, GLMakie
using Makie.GeometryBasics
using MuladdMacro
# =====USING Additional Functions =====================
include("Additional_Functions.jl")
Additional_Functions()
## ============== Initialization =========================  
examples = "Lbracket2d"     # Name of model
OPT, FE = Generate_Struct() # Initialization of OPT, FE structs
path_output = "outputs/" * examples * "/"
OPT.examples = examples     # Update name of model
OPT.fd_step_size = 1e-8     # Finite difference step
## ========================================================= 
OPT.fd_check = 1         # run finite difference check 1-Yes, 0-No
OPT.run_multi_scales = 1   # run TOP with multi scales   1-Yes, 0-No
OPT.run_stress = 1         # run TOP with stress         1-Yes, 0-No
OPT.run_SGs = 1            # run TOP with using surrogate models of stress and fatigue 1-Yes, 0-No
OPT.options.max_iter = 200 # maximum iteration of TOP
## ==========================================================
print("Start: ... \n")
print("Problem: " * examples * "\n")
##==========================================================
OPT, FE = get_inputs(OPT, FE)   # get inputs from models
# # ====================FEM=================================
OPT, FE = init_FE(OPT, FE)      # Initialization of FEM model
OPT, FE = perform_analysis(OPT, FE)           # Run 1st FEM analysis
print("Cell size = ", FE.max_elem_side, "\n")
print("Number of elements = ", FE.n_elem, "\n")
print("Start time: ", Dates.format(now(), "yyyy-mm-dd HH:MM"), "\n")
# ============RUN FINITE DIFFERENCE CHECK===============
if OPT.fd_check == true
    check_cost_sens, check_const_sens = 1, 1
    figs = run_finite_difference_check(OPT, FE, check_cost_sens, check_const_sens, path_output)
    display(figs[2])
else
    # ================RUN OPTIMIZATION=======================
    print("Start topology optimization: \n")
    print("Objective: " * OPT.functions.objective * "\n")
    print("Constraint: " * OPT.functions.constraints * "\n")
    x0 = copy(OPT.dv)    # Initialization of design variables
    # !!!!!!!!!!!!!!!!!!!!!!!!!!    include("Main_Julia_Top_TPMS.jl")     !!!!!!!!!!!!!!!!!!!!!
    OPT, FE, history = runmma(OPT, FE, x0, path_output) # The Method of Moving Asymptotes
    writevtk_stress = OPT.run_stress
    writevtk(OPT, FE, path_output, writevtk_stress)
    # Produce output to screen
    # compliance = OPT.compliance
    # vf = OPT.volume_fraction
    # @printf("Compliance of final design = %-12.5e, Volume fraction = %-12.5e ", compliance, vf)
    ## ================PLOTTING=======================
    figs = plot_design(OPT, FE, history, path_output)
    figs[1]

end
print("End time: ", Dates.format(now(), "yyyy-mm-dd HH:MM"), "\n")
figs[1]

print("COMPLETED", "\n")