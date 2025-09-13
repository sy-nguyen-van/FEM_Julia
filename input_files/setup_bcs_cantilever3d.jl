function setup_bcs_cantilever3d(OPT::OPT_struct, FE::FE_struct)
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
    if FE.dim == 3
        coord_z = FE.coords[3, :]
    end
    ## ============================
    ## Compute predefined node sets
    FE = compute_predefined_node_sets(FE, ["MRK_pt", "K_face", "L_face", "R_face"])
    # for an overview of this function, use: help compute_predefined_node_sets
    MRK_pt = FE.node_set.MRK_pt
    # To distribute load in semi-circular region (recall symmetry bcs), find
    # all nodes in left face within a distance r of the mid right-back edge
    # point (MRK_pt).
    r = 1
    dist_Rface_neighbors = ((coord_x[Int.(FE.node_set.R_face)] .- coord_x[Int.(MRK_pt)]) .^ 2 +
                             (coord_y[Int.(FE.node_set.R_face)] .- coord_y[Int.(MRK_pt)]) .^ 2 +
                             (coord_z[Int.(FE.node_set.R_face)] .- coord_z[Int.(MRK_pt)]) .^ 2) .^ 0.5

    MRK_neighbors = FE.node_set.R_face[findall(dist_Rface_neighbors .<= r)]

    K_face = FE.node_set.K_face
    L_face = FE.node_set.L_face
    ## ============================        
    ## Number of load cases
    # Note: in this implementation, load cases can have different forces, but
    # displacement boundary conditions must be the same for all load cases.
    FE.nloads = 1
    ## ============================        
    ## Applied forces
    net_mag = OPT.load_amplitude
    load_dir = 2   # Force direction 
    load_region = MRK_neighbors
    load_mag = net_mag / length(load_region)
    # Here, we build the array with all the loads.  If you have multiple
    # applied loads, the load_mat array must contain all the loads as follows:
    #  - There is one row per each load on a degree of freedom
    #  - Column 1 has the node id where the load is applied
    #  - Column 2 has the direction (1 -> x, 2 -> y, 3 -> z)
    #  - Column 3 has the load magnitude.
    #  - Column 4 has the load case number.
    load_mat = zeros(length(load_region), 4)
    load_mat[:, 1] = load_region
    load_mat[:, 2] = load_dir * ones(size(load_mat[:, 2]))
    load_mat[:, 3] = load_mag * ones(size(load_mat[:, 3]))
    load_mat[:, 4] = ones(size(load_mat[:, 4]))
    n_force_dofs = size(load_mat, 1)
    ## Displacement boundary conditions
    # Encastre at left-side face
    disp_region = L_face
    disp_mag = zeros(1, length(disp_region))
    disp_dirs1 = ones(1, length(disp_region))
    disp_dirs2 = 2 * ones(1, length(disp_region))
    disp_dirs3 = 3 * ones(1, length(disp_region))
    # Symmetry at back-side face
    disp_region2 = K_face
    disp_mag2 = zeros(1, length(disp_region2))
    disp_dirs4 = 3 * ones(1, length(disp_region2))
    # Combine displacement BC regions
    disp_region = vec([disp_region; disp_region; disp_region; disp_region2])
    disp_dirs = vec([vec(disp_dirs1); vec(disp_dirs2); vec(disp_dirs3); vec(disp_dirs4)])
    disp_mag = vec([vec(disp_mag); vec(disp_mag); vec(disp_mag); vec(disp_mag2)])

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
    FE.BC.n_pre_force_dofs = [n_force_dofs] # # of prescribed force dofs
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