function setup_bcs_mbb2d(OPT::OPT_struct, FE::FE_struct)
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



    W = FE.mesh_input.box_dimensions[1]
    H = FE.mesh_input.box_dimensions[2]
    lw = W / 60

    tol = FE.max_elem_side / 1000

    load_nodes = findall(Bool.(FE.coords[2, :] .> (H - tol)) .&& Bool.(FE.coords[1, :] .< (lw + tol)) .&& Bool.(FE.coords[1, :] .> -tol))

    roller_nodes = findall(Bool.(FE.coords[2, :] .< tol) .&& Bool.(FE.coords[1, :] .> (W - lw - tol)))

    L_edge = findall(Bool.(FE.coords[1, :] .< tol))

    # To distribute load in semi-circular region (recall symmetry bcs), find

    ## ============================        
    ## Number of load cases
    # Note: in this implementation, load cases can have different forces, but
    # displacement boundary conditions must be the same for all load cases.
    FE.nloads = 1
    ## Applied forces
    # Load case 1 
    net_mag = OPT.load_amplitude
    load_dir = 2   # Force direction 
    load_region = load_nodes
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
    # Symmetry boundary condition on left-hand side edge
    disp_region1 = L_edge
    disp_dirs1 = ones(length(disp_region1))
    disp_mag1 = zeros(length(disp_region1))
    # Vertical roller on bottom-right point
    disp_region2 = roller_nodes
    disp_dirs2 = 2 * ones(length(disp_region2))
    disp_mag2 = zeros(length(disp_region2))
    # Combine displacement BC regions
    disp_region = vec([disp_region1; disp_region2])
    disp_dirs = vec([disp_dirs1; disp_dirs2])
    disp_mag = vec([disp_mag1; disp_mag2])

    # Here, we build the array with all the displacement BCs. 
    # The disp_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the displacement BC is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the displacement magnitude.
    # 
    disp_mat = zeros(length(disp_region), 3)
    for idisp in 1:length(disp_region)
        disp_mat[idisp, 1] = disp_region[idisp]
        disp_mat[idisp, 2] = disp_dirs[idisp]
        disp_mat[idisp, 3] = disp_mag[idisp]
    end

    # *** Do not modify the code below ***
    #
    # Write displacement boundary conditions and forces to the global FE
    # structure.
    #
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
