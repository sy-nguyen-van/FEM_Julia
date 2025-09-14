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
examples = "cantilever2d"     # Name of model
OPT, FE = Generate_Struct() # Initialization of OPT, FE structs
path_output = "outputs/" * examples * "/"  # path of output folders
OPT.examples = examples     # Update name of model
## =========================================================
print("Start: ... \n")
print("Problem: " * examples * "\n")
##==========================================================
OPT, FE = get_inputs(OPT, FE)   # get inputs from models
# # ====================FEM=================================
OPT, FE = init_FE(OPT, FE)      # Initialization of FEM model
OPT, FE = perform_analysis(OPT, FE)  # Run 1st FEM analysis
FE = compute_stress(FE)
writevtk(OPT, FE, path_output)










