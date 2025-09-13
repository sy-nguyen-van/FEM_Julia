function setup_bcs_cantilever2d(OPT::OPT_struct, FE::FE_struct)
    ## Input file 
    #
    # *** THIS SCRIPT HAS TO BE CUSTOMIZED BY THE USER ***
    #
    # This script sets up the displacement boundary conditions and the forces
    # for the analysis. 
    #
    # Important note: you must make sure you do not simultaneously impose 
    # displacement boundary conditions and forces on the same degree of
    # freedom.

    # ** Do not modify this line **

    coord_x = FE.coords[1, :]
    coord_y = FE.coords[2, :]

    ## ============================
    # ## Compute predefined node sets
    # FE = compute_predefined_node_sets(FE, ["BR_pt", "L_edge"])
    # # for an overview of this function, use: help compute_predefined_node_sets
    # BR_pt  = Int.(FE.node_set.BR_pt)
    # L_edge = Int.(FE.node_set.L_edge)
    # To distribute load in semi-circular region (recall symmetry bcs), find
    # Apply forces over 1/8 of the top portion of the right-hand edge

    W = FE.mesh_input.box_dimensions[1]
    H = FE.mesh_input.box_dimensions[2]
    tol = FE.max_elem_side / 1000

    # Apply forces over 1/8 of the top portion of the right-hand edge
    BR_pt = findall(Bool.(FE.coords[1, :] .> (W - tol)) .&& Bool.(FE.coords[2, :] .< (1 / 8)*H + tol) .&& Bool.(FE.coords[2, :] .> -tol))
    # Apply forces over 1/8 of the low portion of the right-hand edge
    L_edge = findall(Bool.(FE.coords[1, :] .< tol))
    ## ============================        
    ## Number of load cases
    # Note: in this implementation, load cases can have different forces, but
    # displacement boundary conditions must be the same for all load cases.
    FE.nloads = 1
    ## Applied forces
    # Load case 1 
    net_mag = OPT.load_amplitude  # Force magnitude (net over all nodes where applied)
    load_dir = 2   # Force direction 

    load_region = BR_pt
    load_mag = net_mag / length(load_region)
    # Here, we build the array with all the loads.  If you have multiple
    # applied loads, the load_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the load is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the load magnitude.
    #  - Column 4 has the load case number.
    #
    load_mat = zeros(length(load_region), 3)
    load_mat[:, 1] = load_region
    load_mat[:, 2] = load_dir * ones(size(load_mat[:, 2]))
    load_mat[:, 3] = load_mag * ones(size(load_mat[:, 3]))
    ## ============================        

    ## Displacement boundary conditions
    #
    disp_mag = 0
    disp_region = L_edge
    disp_dirs = [1, 2]    # In this example, we are constraining both the x- 
    # and y- displacements. 
    ## Displacement boundary conditions
    #
    # NOTE: only one set of displacement boundary conditions is supported.
    # I.e., there can be different forces in different load cases, but only one
    # set of supports.
    #
    disp_mat = zeros(length(disp_region) * length(disp_dirs), 3)
    size_disp = length(disp_dirs)
    for idir in 1:size_disp
        idx_start = 1 + (idir - 1) * length(disp_region)
        idx_end = idir * length(disp_region)
        disp_mat[idx_start:idx_end, 1] .= disp_region
        disp_mat[idx_start:idx_end, 2] .= disp_dirs[idir]
        disp_mat[idx_start:idx_end, 3] .= disp_mag
    end
    # In this example we are constraining both the x- and y-directions along
    # the top edge.

    # Here, we build the array with all the displacement BCs. 
    # The disp_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the displacement BC is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the displacement magnitude.

    # Note: you must assign values for all of the variables below.
    #


    FE.BC.n_pre_force_dofs .= size(load_mat, 1) # # of prescribed force dofs
    FE.BC.n_pre_disp_dofs = size(disp_mat, 1) # # of prescribed displacement dofs

    FE.BC.force_node = vec(transpose(Int.(load_mat[:, 1])))
    FE.BC.force_dof = vec(transpose(load_mat[:, 2]))
    FE.BC.force_value = vec(transpose(load_mat[:, 3]))
    FE.BC.n_pre_disp_dofs = size(disp_mat, 1) # # of prescribed displacement dofs
    FE.BC.disp_node = vec(transpose(disp_mat[:, 1]))
    FE.BC.disp_dof = vec(transpose(disp_mat[:, 2]))
    FE.BC.disp_value = vec(transpose(disp_mat[:, 3]))

    return FE
end
