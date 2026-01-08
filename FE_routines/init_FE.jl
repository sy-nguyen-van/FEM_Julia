include("FE_compute_element_info.jl")
include("FE_init_partitioning.jl")
include("FE_assemble_BC.jl")

include("genLbracketmesh.jl")
include("generate_mesh.jl")
include("genVframemesh.jl")
include("gendoubleLbracketmesh.jl")

function init_FE(OPT::OPT_struct, FE::FE_struct)
    # Initialize the Finite Element structure
    #"Lbracket2d"; "cracked_plate2d"; "Vframe2d"; "doubleLbracket2d" ; "cantilever3d"

    if FE.mesh_input.type == "Lbracket2d"
        FE = genLbracketmesh(FE)
        FE.elem_type = fill(:CPS4, FE.n_elem)
    elseif FE.mesh_input.type == "generate"
        FE = generate_mesh(FE)
    elseif FE.mesh_input.type == "V-frame"
        FE = genVframemesh(FE)
    elseif FE.mesh_input.type == "doubleLbracket2d"
        FE = gendoubleLbracketmesh(FE)
    elseif FE.mesh_input.type == "Lbracket2d_2_Loads"
        FE = genLbracketmesh(FE)
    else
        name_file = "Mesh_files/" * OPT.examples
        FE = read_mesh_Abaqus(FE, name_file)
    end
    # # Compute element volumes and centroidal coordinates
    FE = FE_compute_element_info(FE)
    ## Setup boundary conditions
    FE = eval(Symbol("setup_bcs_" * OPT.examples))(OPT, FE)
    # # # initialize the fixed/free partitioning scheme:
    FE = FE_init_partitioning(FE)
    # # # # assemble the boundary conditions
    FE = FE_assemble_BC(FE)
    # # # # initilization of optimization
    OPT, FE = init_optimization(OPT, FE)
    # Material elasticity tensor
    if FE.dim == 2
        FE.Ce = SharedArray{Float64}(3, 3, FE.n_elem)
        FE.V = [1 -1/2 0; -1/2 1 0; 0 0 3]
    elseif FE.dim == 3
        FE.Ce = SharedArray{Float64}(6, 6, FE.n_elem)
        FE.V = [1 -1/2 -1/2 0 0 0; -1/2 1 -1/2 0 0 0; -1/2 -1/2 1 0 0 0;
            0 0 0 3 0 0; 0 0 0 0 3 0; 0 0 0 0 0 3]
    end
    # inititalize element stiffness matrices
    FE.Ke = SharedArray{Float64}(FE.n_edof, FE.n_edof, FE.n_elem)
    # Material elasticity tensor
    #-----------------------------------
    FE.B0e = SharedArray{Float64}(3 * (FE.dim - 1), FE.n_edof, FE.n_elem)
    # ==========================
    OPT, FE = FE_compute_element_stiffness(OPT, FE)
    return OPT, FE
end
