function compute_predefined_node_sets(FE::FE_struct, requested_node_set_list)
    #
    # This function computes the requested node sets and stores them as 
    # members of FE.node_set.
    #
    # Input is a cell array of strings identifying the node sets to compute
    # e.g. {"T_edge","BR_pt"}
    #
    # this function predefines certain sets of nodes (requested by the user)
    # that you can use for convenience to define displacement boundary
    # conditions and forces.  IMPORTANT: they only make sense (in general) for
    # rectangular / cuboidal meshes, and you must be careful to use them and/or
    # change the code according to your needs.
    #
    # Note that an advantage of using these node sets is that you can use them
    # with meshes that have different element sizes (but same dimensions)
    #
    #--------------------------------------------------------------------------
    # 2D:
    #
    #  Edges:                  Points:
    #   -----Top (T)-----          TL-------MT-------TR
    #  |                 |          |                 |
    #  |                 |          |                 |   
    # Left (L)         Right (R)   ML                MR   | y
    #  |                 |          |                 |   |
    #  |                 |          |                 |   |
    #   ---Bottom (B)----          BL-------MB-------BR    ----- x
    #
    #--------------------------------------------------------------------------
    # 3D:
    #
    #  Faces:                                Edges:            
    #                     Back (K)     
    #               -----------------                   -------TK--------          
    #             /|                /|                /|                /|
    #            / |   Top (T)     / |              TL |              TR |
    #           /  |              /  |              /  LK             /  RK
    #          |-----------------|   |             |-------TF--------|   |
    # Left (L) |   |             |   | Right (R)   |   |             |   |
    #          |  / -------------|--/             LF  / -------BK----RF-/
    #          | /   Bottom (B)  | /               |BL               | BR 
    #          |/                |/                |/                |/
    #           -----------------                   -------BF--------
    #                Front (F)
    #
    #  Points:                                       
    #         TLK---------------TRK    For edge midpoints:       
    #         /|                /|       Add "M" to the edge    
    #        / |               / |       notation, e.g.,           
    #       /  |              /  |       "MTK" is the midpoint    | y
    #     TLF---------------TRF  |       of edge "TK".            |
    #      |   |             |   |                                | 
    #      |  BLK------------|--BRK    For face midpoints:         ---- x    
    #      | /               | /          Add "M" to the face    /    
    #      |/                |/           notation, e.g.,       / 
    #     BLF---------------BRF           "MT" is the midpoint   z
    #                                     of face "T".


    ## determine which node sets to compute from input list
    msg_odd_n_elem = "The number of elements along a dimension " *
                     "requesting a midpoint is odd,\n returning empty list of nodes."

    nel_odd = mod.(FE.mesh_input.elements_per_side[:], 2) .!= 0

    coord_x = FE.coords[1, :]
    coord_y = FE.coords[2, :]
    if FE.dim == 3
        coord_z = FE.coords[3, :]
    end


    tol = maximum(abs.(FE.coord_max .- FE.coord_min)) / 1e6
    minX = FE.coord_min[1]
    maxX = FE.coord_max[1]
    avgX = (maxX - minX) / 2
    minY = FE.coord_min[2]
    maxY = FE.coord_max[2]
    avgY = (maxY - minY) / 2
    if FE.dim == 3
        minZ = FE.coord_min[3]
        maxZ = FE.coord_max[3]
        avgZ = (maxZ - minZ) / 2
    end
    # ---------------------------------------------------
    size_list = length(requested_node_set_list)
    if FE.dim == 2
        for i in 1:size_list
            # == Edges ==
            if requested_node_set_list[i] == "T_edge"
                FE.node_set.T_edge = findall(coord_y .> maxY - tol)
            elseif requested_node_set_list[i] == "B_edge"
                FE.node_set.B_edge = findall(coord_y .< minY + tol)
            elseif requested_node_set_list[i] == "L_edge"
                FE.node_set.L_edge = findall(coord_x .< minX + tol)
            elseif requested_node_set_list[i] == "R_edge"
                FE.node_set.R_edge = findall(coord_x .> maxX - tol)
                # == Points ==
            elseif requested_node_set_list[i] == "BL_pt"
                FE.node_set.BL_pt =
                    findall(coord_x .< minX + tol .&& coord_y .< minY + tol)
            elseif requested_node_set_list[i] == "BR_pt"
                FE.node_set.BR_pt =
                    findall(coord_x .> maxX - tol .&& coord_y .< minY + tol)
            elseif requested_node_set_list[i] == "TR_pt"
                FE.node_set.TR_pt =
                    findall(coord_x .> maxX - tol .&& coord_y .> maxY - tol)
            elseif requested_node_set_list[i] == "TL_pt"
                FE.node_set.TL_pt =
                    findall(coord_x .< minX + tol .&& coord_y .> maxY - tol)
                # Note: the following ones only work if there is an even number of
                # elements on the corresponding sides, i.e., there is a node exactly in
                # the middle of the side.
            elseif requested_node_set_list[i] == "ML_pt"
                FE.node_set.ML_pt =
                    findall(coord_x .< minX + tol .&& coord_y .> avgY - tol .&& coord_y .< avgY + tol)
                if nel_odd[2] # # of y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
            elseif requested_node_set_list[i] == "MR_pt"
                FE.node_set.MR_pt =
                    findall(coord_x .> maxX - tol .&& coord_y .> avgY - tol .&& coord_y .< avgY + tol)
                if nel_odd[2] # # of y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
            elseif requested_node_set_list[i] == "MB_pt"
                FE.node_set.MB_pt =
                    findall(coord_y .< minY + tol .&& coord_x .> avgX - tol .&& coord_x .< avgX + tol)
                if nel_odd[1] # # of x elements is odd
                    @warn(msg_odd_n_elem, [])
                end
            elseif requested_node_set_list[i] == "MT_pt"
                FE.node_set.MT_pt =
                    findall(coord_y .> maxY - tol .&& coord_x .> avgX - tol
                            .&& coord_x .< avgX + tol)
                if nel_odd[1] # # of x elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                # Volume-center point
            elseif requested_node_set_list[i] == "C_pt"
                if nel_odd[1] || nel_odd[2] # # of x or y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.C_pt = findall(coord_y .> avgY - tol .&& coord_y .< avgY + tol .&& coord_x .> avgX - tol .&& coord_x .< avgX + tol)
            end
        end
    elseif FE.dim == 3
        for i = 1:size_list
            # == Faces ==
            if requested_node_set_list[i] == "T_face"
                FE.node_set.T_face = findall(coord_y .> maxY - tol)
            elseif requested_node_set_list[i] == "B_face"
                FE.node_set.B_face = findall(coord_y .< minY + tol)
            elseif requested_node_set_list[i] == "L_face"
                FE.node_set.L_face = findall(coord_x .< minX + tol)
            elseif requested_node_set_list[i] == "R_face"
                FE.node_set.R_face = findall(coord_x .> maxX - tol)
            elseif requested_node_set_list[i] == "K_face"
                FE.node_set.K_face = findall(coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "F_face"
                FE.node_set.F_face = findall(coord_z .> maxZ - tol)
                # == Edges ==
            elseif requested_node_set_list[i] == "TK_edge"
                FE.node_set.TK_edge = findall(coord_y .> maxY - tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "BK_edge"
                FE.node_set.BK_edge = findall(coord_y .< minY + tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "LK_edge"
                FE.node_set.LK_edge = findall(coord_x .< minX + tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "RK_edge"
                FE.node_set.RK_edge = findall(coord_x .> maxX - tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "TF_edge"
                FE.node_set.TF_edge = findall(coord_y .> maxY - tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "BF_edge"
                FE.node_set.BF_edge = findall(coord_y .< minY + tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "LF_edge"
                FE.node_set.LF_edge = findall(coord_x .< minX + tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "RF_edge"
                FE.node_set.RF_edge = findall(coord_x .> maxX - tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "TL_edge"
                FE.node_set.TL_edge = findall(coord_y .> maxY - tol .&& coord_x .< minX - tol)
            elseif requested_node_set_list[i] == "TR_edge"
                FE.node_set.TR_edge = findall(coord_y .> maxY - tol .&& coord_x .> maxX - tol)
            elseif requested_node_set_list[i] == "BL_edge"
                FE.node_set.BL_edge = findall(coord_y .< minY + tol .&& coord_x .< minX - tol)
            elseif requested_node_set_list[i] == "BR_edge"
                FE.node_set.BR_edge = findall(coord_y .< minY + tol .&& coord_x .> maxX - tol)
                # == Points ==
            elseif requested_node_set_list[i] == "BLK_pt"
                FE.node_set.BLK_pt = findall(coord_x .< minX + tol .&& coord_y .< minY + tol .&&
                                             coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "BRK_pt"
                FE.node_set.BRK_pt = findall(coord_x .> maxX - tol .&& coord_y .< minY + tol .&&
                                             coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "TRK_pt"
                FE.node_set.TRK_pt = findall(coord_x .> maxX - tol .&& coord_y .> maxY - tol .&&
                                             coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "TLK_pt"
                FE.node_set.TLK_pt = findall(coord_x .< minX + tol .&& coord_y .> maxY - tol .&&
                                             coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "BLF_pt"
                FE.node_set.BLF_pt = findall(coord_x .< minX + tol .&& coord_y .< minY + tol .&&
                                             coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "BRF_pt"
                FE.node_set.BRF_pt = findall(coord_x .> maxX - tol .&& coord_y .< minY + tol .&&
                                             coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "TRF_pt"
                FE.node_set.TRF_pt = findall(coord_x .> maxX - tol .&& coord_y .> maxY - tol .&&
                                             coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "TLF_pt"
                FE.node_set.TLF_pt = findall(coord_x .< minX + tol .&& coord_y .> maxY - tol .&&
                                             coord_z .> maxZ - tol)
                # *****
                # Note: the following ones only work if there is an even number of
                # elements on the corresponding sides, i.e., there is a node exactly in
                # the middle of the side.
                #
                # Mid-edge points
            elseif requested_node_set_list[i] == "MLK_pt"
                if nel_odd[2] # # of y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MLK_pt = findall(coord_x .< minX + tol .&& coord_y .> avgY - tol
                                             .&& coord_y .< avgY + tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "MRK_pt"
                if nel_odd[2] # # of y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MRK_pt = findall(coord_x .> maxX - tol .&& coord_y .> avgY - tol
                                             .&& coord_y .< avgY + tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "MBK_pt"
                if nel_odd[1] # # of x elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MBK_pt = findall(coord_y .< minY + tol .&& coord_x .> avgX - tol
                                             .&& coord_x .< avgX + tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "MTK_pt"
                if nel_odd[1] # # of x elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MTK_pt = findall(coord_y .> maxY - tol .&& coord_x .> avgX - tol
                                             .&& coord_x .< avgX + tol .&& coord_z .< minZ + tol)
            elseif requested_node_set_list[i] == "MLF_pt"
                if nel_odd[2] # # of y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MLF_pt = findall(coord_x .< minX + tol .&& coord_y .> avgY - tol
                                             .&& coord_y .< avgY + tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "MRF_pt"
                if nel_odd[2] # # of y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MRF_pt = findall(coord_x .> maxX - tol .&& coord_y .> avgY - tol
                                             .&& coord_y .< avgY + tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "MBF_pt"
                if nel_odd[1] # # of x elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MBF_pt = findall(coord_y .< minY + tol .&& coord_x .> avgX - tol
                                             .&& coord_x .< avgX + tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "MTF_pt"
                if nel_odd[1] # # of x elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MTF_pt = findall(coord_y .> maxY - tol .&& coord_x .> avgX - tol
                                             .&& coord_x .< avgX + tol .&& coord_z .> maxZ - tol)
            elseif requested_node_set_list[i] == "MBL_pt"
                if nel_odd[3] # # of z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MBL_pt = findall(coord_x .< minX + tol .&& coord_z .> avgZ - tol
                                             .&& coord_z .< avgZ + tol .&& coord_y .< minY + tol)
            elseif requested_node_set_list[i] == "MBR_pt"
                if nel_odd[3] # # of z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MBR_pt = findall(coord_x .> maxX - tol .&& coord_z .> avgZ - tol
                                             .&& coord_z .< avgZ + tol .&& coord_y .< minY + tol)
            elseif requested_node_set_list[i] == "MTL_pt"
                if nel_odd[3] # # of z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MTL_pt = findall(coord_x .< minX + tol .&& coord_z .> avgZ - tol
                                             .&& coord_z .< avgZ + tol .&& coord_y .> maxY - tol)
            elseif requested_node_set_list[i] == "MTR_pt"
                if nel_odd[3] # # of z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MTR_pt = findall(coord_x .> maxX - tol .&& coord_z .> avgZ - tol
                                             .&& coord_z .< avgZ + tol .&& coord_y .> maxY - tol)
                # Mid-face points
            elseif requested_node_set_list[i] == "MB_pt"
                if nel_odd[1] || nel_odd[3] # # of x or z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MB_pt = findall(coord_y .< minY + tol .&&
                                            coord_x .> avgX - tol .&& coord_x .< avgX + tol .&&
                                            coord_z .> avgZ - tol .&& coord_z .< avgZ + tol)
            elseif requested_node_set_list[i] == "MT_pt"
                if nel_odd[1] || nel_odd[3] # # of x or z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MT_pt = findall(coord_y .> maxY - tol .&&
                                            coord_x .> avgX - tol .&& coord_x .< avgX + tol .&&
                                            coord_z .> avgZ - tol .&& coord_z .< avgZ + tol)
            elseif requested_node_set_list[i] == "ML_pt"
                if nel_odd[2] || nel_odd[3] # # of y or z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.ML_pt = findall(coord_x .< minX + tol .&&
                                            coord_y .> avgY - tol .&& coord_y .< avgY + tol .&&
                                            coord_z .> avgZ - tol .&& coord_z .< avgZ + tol)
            elseif requested_node_set_list[i] == "MR_pt"
                if nel_odd[2] || nel_odd[3] # # of y or z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MR_pt = findall(coord_x .> maxX - tol .&&
                                            coord_y .> avgY - tol .&& coord_y .< avgY + tol .&&
                                            coord_z .> avgZ - tol .&& coord_z .< avgZ + tol)
            elseif requested_node_set_list[i] == "MK_pt"
                if nel_odd[1] || nel_odd[2] # # of x or y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MK_pt = findall(coord_z .< minZ + tol .&&
                                            coord_y .> avgY - tol .&& coord_y .< avgY + tol .&&
                                            coord_x .> avgX - tol .&& coord_x .< avgX + tol)
            elseif requested_node_set_list[i] == "MF_pt"
                if nel_odd[1] || nel_odd[2] # # of x or y elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.MF_pt = findall(coord_z .> maxZ - tol .&&
                                            coord_y .> avgY - tol .&& coord_y .< avgY + tol .&&
                                            coord_x .> avgX - tol .&& coord_x .< avgX + tol)
                # Volume-center point
            elseif requested_node_set_list[i] == "C_pt"
                if nel_odd[1] || nel_odd[2] || nel_odd[3] # # of x,y or z elements is odd
                    @warn(msg_odd_n_elem, [])
                end
                FE.node_set.C_pt = findall(coord_z .< minZ + tol .&& coord_z .> maxZ - tol .&&
                                           coord_y .> avgY - tol .&& coord_y .< avgY + tol .&&
                                           coord_x .> avgX - tol .&& coord_x .< avgX + tol)
            end
        end
    end


    return FE
end
