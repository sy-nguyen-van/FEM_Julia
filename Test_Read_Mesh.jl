using AbaqusReader
using LinearAlgebra
using SharedArrays
## ========INCLUDE PACKAGES=========
using Dates, BenchmarkTools, DelimitedFiles, Printf
using CSV, DataFrames
using StaticArrays, Statistics, SparseArrays
using Kronecker, NearestNeighbors, LazyGrids
using Makie, CairoMakie
using Makie.GeometryBasics
using MuladdMacro
using MshReader
# =====USING Additional Functions =====================
include("Additional_Functions.jl")
Additional_Functions()
## ============== Initialization =========================  
# ===2D PROBLEMS===
# "Lbracket2d"; "cracked_plate2d"; 
# "Vframe2d";   "cantilever2d"; 
# "mbb2d";      "doubleLbracket2d"
# Lbracket2d_2_Loads
# === 3D PROBLEMS ===
# "cantilever3d"   PennState_3points_bending
examples = "cantilever2d"     # Name of model
OPT, FE = Generate_Struct() # Initialization of OPT, FE structs
path_output = "outputs/" * examples * "/"  # path of output folders
OPT.examples = examples     # Update name of model
OPT.fd_step_size = 1e-8     # Finite difference step
## ==========================================================
print("Start: ... \n")
print("Problem: " * examples * "\n")
##==========================================================
OPT, FE = get_inputs(OPT, FE)   # get inputs from models
# # ====================FEM=================================
OPT, FE = init_FE(OPT, FE)      # Initialization of FEM model
OPT, FE = perform_analysis(OPT, FE)  # Run 1st FEM analysis
# print("Cell size = ", FE.max_elem_side, "\n")
# print("Number of elements = ", FE.n_elem, "\n")
# print("Start time: ", Dates.format(now(), "yyyy-mm-dd HH:MM"), "\n")
# # @btime maximum_stress_SGs(OPT, FE, SGs)

