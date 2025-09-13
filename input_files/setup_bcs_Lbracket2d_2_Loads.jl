function setup_bcs_Lbracket2d_2_Loads(OPT::OPT_struct, FE::FE_struct)
    # Apply forces over 1/8 of the top portion of the right-hand edge
    l = FE.mesh_input.L_side
    c = FE.mesh_input.L_cutout

    tol = FE.max_elem_side / 1000
    # Apply forces over 1/8 of the top portion of the right-hand edge
    TR_pt = findall(Bool.(FE.coords[1, :] .> (l - tol)) .&& Bool.(FE.coords[2, :] .> (7 / 8) * (l - c) - tol) .&& Bool.(FE.coords[2, :] .< l - c + tol))
    # Apply forces over 1/8 of the low portion of the right-hand edge
    LR_pt = findall(Bool.(FE.coords[1, :] .> (l - tol)) .&& Bool.(FE.coords[2, :] .> - tol) .&& Bool.(FE.coords[2, :] .< (1 / 8) * (l - c) + tol))
    # Apply forces over all of the top-edge
    T_edge = findall(Bool.(FE.coords[2, :] .> l - tol))
    ## ============================        
    ## Number of load cases
    # Note: in this implementation, load cases can have different forces, but
    # displacement boundary conditions must be the same for all load cases.       
    ## Applied forces
    # Load case 1 
    FE.nloads = 2
    net_mag1 = OPT.load_amplitude  # Force magnitude (net over all nodes where applied)

    load_dir1 = 2   # Force direction 
    load_region1 = TR_pt
    load_mag1 = net_mag1 / length(load_region1)
    # Here, we build the array with all the loads.  If you have multiple
    # applied loads, the load_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the load is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the load magnitude.
    #  - Column 4 has the load case number.
    load_mat1 = zeros(length(load_region1), 4)
    load_mat1[:, 1] = load_region1
    load_mat1[:, 2] = load_dir1 * ones(size(load_mat1[:, 2]))
    load_mat1[:, 3] = load_mag1 * ones(size(load_mat1[:, 3]))
    load_mat1[:, 4] = ones(size(load_mat1[:, 4]))
    n_force_dofs1 = size(load_mat1, 1)

    # Load case 2 
    net_mag2 = copy(net_mag1)  # Force magnitude (net over all nodes where applied)
    load_dir2 = 1   # Force direction 

    load_region2 = LR_pt # LR_pt LL_pt
    load_mag2 = net_mag2 / length(load_region2)

    # Here, we build the array with all the loads.  If you have multiple
    # applied loads, the load_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the load is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the load magnitude.
    #  - Column 4 has the load case number.
    #
    load_mat2 = zeros(length(load_region2), 4)
    load_mat2[:, 1] = load_region2
    load_mat2[:, 2] = load_dir2 * ones(size(load_mat2[:, 2]))
    load_mat2[:, 3] = load_mag2 * ones(size(load_mat2[:, 3]))
    load_mat2[:, 4] = 2 * ones(size(load_mat2[:, 4]))
    n_force_dofs2 = size(load_mat2, 1)
    ## ============================        
    ## Combine load cases if needed
    load_mat = [load_mat1; load_mat2]
    n_force_dofs = [n_force_dofs1, n_force_dofs2]
    ## Displacement boundary conditions
    #
    # NOTE: only one set of displacement boundary conditions is supported.
    # I.e., there can be different forces in different load cases, but only one
    # set of supports.
    #
    disp_region = T_edge
    disp_dirs1 = ones(1, length(disp_region))
    disp_mag = zeros(1, length(disp_region))
    disp_dirs2 = 2 * ones(1, length(disp_region))

    # Combine displacement BC regions
    disp_region = vec([disp_region; disp_region])
    disp_dirs = vec([vec(disp_dirs1); vec(disp_dirs2)])
    disp_mag = vec([vec(disp_mag); vec(disp_mag)])
    # In this example we are constraining both the x- and y-directions along
    # the top edge.

    # Here, we build the array with all the displacement BCs. 
    # The disp_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the displacement BC is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the displacement magnitude.
    # 
    disp_mat = zeros(length(disp_region), 3)
    i_index = length(disp_region)
    for idisp in 1:i_index
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
    FE.BC.n_pre_force_dofs = n_force_dofs # # of prescribed force dofs
    FE.BC.force_node = vec(transpose(Int.(load_mat[:, 1])))
    FE.BC.force_dof = vec(transpose(load_mat[:, 2]))
    FE.BC.force_value = vec(transpose(load_mat[:, 3]))
    FE.BC.force_id = Int.(load_mat[:, 4])
    FE.BC.n_pre_disp_dofs = size(disp_mat, 1) # # of prescribed displacement dofs
    FE.BC.disp_node = vec(transpose(disp_mat[:, 1]))
    FE.BC.disp_dof = vec(transpose(disp_mat[:, 2]))
    FE.BC.disp_value = vec(transpose(disp_mat[:, 3]))

    return FE
end