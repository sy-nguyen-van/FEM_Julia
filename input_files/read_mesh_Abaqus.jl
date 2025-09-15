function build_FE_arrays(model::Dict)
    # --- Nodes ---
    ind_nodes = sort(collect(keys(model["nodes"])))
    nnodes    = length(ind_nodes)
    ndim      = length(first(values(model["nodes"])))
    FE_coords = hcat([model["nodes"][nid] for nid in ind_nodes]...)  # 3 × n_nodes

    # --- Elements ---
    elem_ids     = sort(collect(keys(model["elements"])))
    nelem        = length(elem_ids)
    nen          = length(model["elements"][first(elem_ids)][2])
    FE_elem_node = hcat([model["elements"][eid][2] for eid in elem_ids]...)
    FE_elem_type = Symbol.((getindex.(values(model["elements"]), 1)))  # convert type strings to symbols

    return FE_coords, FE_elem_node, FE_elem_type, nelem, nnodes
end

# --------------------------------------------------------
function read_mesh_Abaqus(FE::FE_struct, name_file)

    model = read_inp_mesh(name_file * ".inp")
    # Access
    FE_coords, FE_elem_node, FE_elem_type, nelem, nnodes = build_FE_arrays(model)
    # =========
    FE.DirichletBC = model["node_sets"]["DirichletBC"]
    FE.NeumannBC = model["node_sets"]["NeumannBC"]
    # FE.RollersBC =  model["node_sets"]["RollersBC"]
    # =========

    FE.coords = FE_coords
    FE.elem_node = FE_elem_node
    FE.elem_type = FE_elem_type
    FE.n_elem = nelem
    FE.n_node = nnodes

    @printf("Imported %d cuboid mesh with %d elements and %d nodes.\n",
        FE.dim, FE.n_elem, FE.n_node)
    # ================================

    return FE

end