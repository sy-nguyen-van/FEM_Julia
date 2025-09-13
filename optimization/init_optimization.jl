function init_optimization(OPT::OPT_struct, FE::FE_struct)
    # -------Upper and lower bounds for sv
    if OPT.run_multi_scales == true
        OPT.LB_macro, OPT.UB_macro = 0, 1.0   # Lower and upper bounds for MACRO scale
        OPT.LB_micro = 0.06   # Lower and upper bounds for MICRO scale
        if OPT.examples == "PennState_3points_bending"
            OPT.LB_macro, OPT.UB_macro = 0.95, 1.0   # Lower and upper bounds for MACRO scale
            OPT.LB_micro = 0.06   # Lower and upper bounds for MICRO scale
        end
        if OPT.examples == "Lbracket2d"
            OPT.LB_macro, OPT.UB_macro = 0, 1.0   # Lower and upper bounds for MACRO scale
            OPT.LB_micro = 0.1   # Lower and upper bounds for MICRO scale
        end
    elseif OPT.run_multi_scales == false
        OPT.LB_micro = 0.0   # Lower and upper bounds for MICRO scale    
    end
    # Maximum thickness of TPMS 
    if OPT.TPMS == "Gyroid"
        OPT.UB_micro = 0.22 # Convert: rho to thickness of TPMS-sheet lattices
    elseif OPT.TPMS == "Primitive"
        OPT.UB_micro = 0.3
    elseif OPT.TPMS == "IWP"
        OPT.UB_micro = 0.2
    end

    # Initialize values of dv
    if OPT.run_multi_scales == true
        OPT.n_dv = FE.n_elem * 2  # No of dv increase 02 times
        OPT.index_dv_macro = vec(1:FE.n_elem)
        OPT.index_dv_micro = vec(FE.n_elem.+1:OPT.n_dv)
        if OPT.fd_check == true
            OPT.dv = vec([OPT.LB_macro .+ rand(FE.n_elem, 1) .* (OPT.UB_macro .- OPT.LB_macro);
                OPT.LB_micro .+ rand(FE.n_elem, 1) .* (OPT.UB_micro .- OPT.LB_micro)])
        else
            OPT.dv = vec([OPT.parameters.init_dens_macro * ones(FE.n_elem, 1);
                OPT.parameters.init_thickness_micro * ones(FE.n_elem, 1)])
        end
    else
        OPT.n_dv = FE.n_elem
        OPT.index_dv_macro = vec(1:FE.n_elem)
        OPT.index_dv_micro = OPT.index_dv_macro
        if OPT.fd_check == true
            OPT.dv = vec(OPT.LB_micro .+ rand(FE.n_elem, 1) .* (OPT.UB_micro .- OPT.LB_micro))
        else
            OPT.dv = vec(OPT.parameters.init_thickness_micro * ones(FE.n_elem, 1))
        end

    end
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # =================================
    # Construct and store filter matrix

    # For each element, find all neighboring elements whose centroids are at a
    # distance <= the filter radius from the element's centroid.
    # Use Matlab's rangesearch function, which uses an efficient kd-tree
    # algorithm.
    if OPT.parameters.filter_radius_factor < 1
        println("Error: filter radius factor must be at least 1.")
        return
    end
    OPT.filter_radius = OPT.parameters.filter_radius_factor * FE.max_elem_side
    # Use a small tolerance to avoid including elements with zero weight in the
    # filter matrix.
    tol = FE.max_elem_side / 1000
    search_dist = OPT.filter_radius - tol
    # Number of neighbors for each element
    balltree = BallTree(FE.centroids)
    OPT_H = zeros(FE.n_elem, FE.n_elem)
    for iel in 1:FE.n_elem
        near_ele = inrange(balltree, FE.centroids[:, iel], search_dist)
        dist = sqrt.(sum((FE.centroids[:, near_ele] .- FE.centroids[:, iel]) .^ 2, dims=1))
        num = 1 .- dist ./ OPT.filter_radius
        den = sum(num)
        OPT_H[iel, near_ele] = num / den
    end
    OPT.H = sparse(OPT_H)

    return OPT, FE
end