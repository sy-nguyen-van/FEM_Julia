
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

# =====USING Additional Functions =====================
include("Additional_Functions.jl")
Additional_Functions()

## ============== Initialization =========================  
examples = "cantilever2d"     # Name of model
OPT, FE = Generate_Struct() # Initialization of OPT, FE structs
OPT.examples = examples     # Update name of model

## =========================================================
print("Start: ... \n")
print("Problem: " * examples * "\n")

# Initialize FE model (loads mesh)
OPT, FE = init_FE(OPT, FE)

# Extract data for plotting
coords = FE.coords
elem_node = FE.elem_node
n_elem = FE.n_elem
n_node = FE.n_node

# Create a figure
fig = Figure(resolution=(800, 600))
ax = Axis(fig[1, 1], aspect=DataAspect(), title="Cantilever 2D Mesh")

# Plot elements
# Assuming CPS4 (quadrilateral) elements for 2D cantilever
# We need to convert connectivity to a format Makie understands or plot as lines/polygons
# For simple visualization, we can plot the wireframe

# Collect all edges
edges = Point2f[]
for i in 1:n_elem
    nodes = elem_node[:, i]
    # Filter out zeros if any (though usually not the case for dense matrices in this context)
    valid_nodes = filter(x -> x != 0, nodes)
    nnodes = length(valid_nodes)

    pts = [Point2f(coords[1, n], coords[2, n]) for n in valid_nodes]

    if nnodes == 3
        push!(edges, pts[1], pts[2])
        push!(edges, pts[2], pts[3])
        push!(edges, pts[3], pts[1])
    elseif nnodes == 4
        push!(edges, pts[1], pts[2])
        push!(edges, pts[2], pts[3])
        push!(edges, pts[3], pts[4])
        push!(edges, pts[4], pts[1])
    end
end

linesegments!(ax, edges, color=:black, linewidth=0.5)

# Save the figure
save("cantilever2d_mesh.png", fig)
println("Mesh saved to cantilever2d_mesh.png")
