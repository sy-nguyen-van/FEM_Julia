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
    elseif FE.mesh_input.type == "generate"
        FE = generate_mesh(FE)
    elseif FE.mesh_input.type == "V-frame"
        FE = genVframemesh(FE)
    elseif FE.mesh_input.type == "doubleLbracket2d"
        FE = gendoubleLbracketmesh(FE)
    elseif FE.mesh_input.type == "Lbracket2d_2_Loads"
        FE = genLbracketmesh(FE)
    else FE.mesh_input.type == "Abaqus_Mesh"
        model = abaqus_read_mesh("Abaqus_Mesh/" * OPT.examples * ".inp")
        ind_nodes = sort(collect(keys(model["nodes"])))   # sorted node IDs
        nnodes = length(ind_nodes)
        ndim = length(first(values(model["nodes"])))
        FE_coords = zeros(ndim, nnodes)
        for (i, i_node) in enumerate(ind_nodes)
            FE_coords[:, i] .= model["nodes"][i_node]   # fill column j with node coords
        end
        # ==========Connectivity========================
        elem_ids = sort(collect(keys(model["elements"])))
        nelem = length(elem_ids)
        nen = length(first(values(model["elements"])))   # nodes per element
        FE_elem_node = zeros(Int, nen, nelem)
        FE_elem_type = Vector{Symbol}(undef, nelem)        # element type
        for (e, eid) in enumerate(elem_ids)
            FE_elem_node[:, e] .= model["elements"][eid]
            FE_elem_type[e] = model["element_types"][eid]
        end
        # =========
        FE.DirichletBC = model["node_sets"]["DirichletBC"]
        FE.NeumannBC = model["node_sets"]["NeumannBC"]
        # =========
        FE.n_elem = nelem
        FE.n_node = nnodes
        FE.coords = FE_coords
        FE.elem_node = FE_elem_node
        FE.elem_type = FE_elem_type
    end
    # # Compute element volumes and centroidal coordinates
    FE = FE_compute_element_info(FE)
    ## Setup boundary conditions
    if OPT.examples == "Lbracket2d"
        FE = setup_bcs_Lbracket2d(OPT, FE)
    elseif OPT.examples == "cantilever2d"   # Name of model
        FE = setup_bcs_cantilever2d(OPT, FE)
    elseif OPT.examples == "mbb2d"   # Name of model
        FE = setup_bcs_mbb2d(OPT, FE)
    elseif OPT.examples == "cracked_plate2d"
        FE = setup_bcs_cracked_plate2d(OPT, FE)
    elseif OPT.examples == "Vframe2d"
        FE = setup_bcs_Vframe2d(OPT, FE)
    elseif OPT.examples == "doubleLbracket2d"
        FE = setup_bcs_doubleLbracket2d(OPT, FE)
    elseif OPT.examples == "cantilever3d"
        FE = setup_bcs_cantilever3d(OPT, FE)
    elseif OPT.examples == "Lbracket2d_2_Loads"
        FE = setup_bcs_Lbracket2d_2_Loads(OPT, FE)
    elseif OPT.examples == "PennState_3points_bending"
        FE = setup_bcs_3points_bending(OPT, FE)
    end
    # # # initialize the fixed/free partitioning scheme:
    FE = FE_init_partitioning(FE)
    # # # # assemble the boundary conditions
    FE = FE_assemble_BC(FE)
    # # # # initilization of optimization
    OPT, FE = init_optimization(OPT, FE)
    # # # # compute the element stiffness matrices
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
