function init_optimization(OPT::OPT_struct, FE::FE_struct)
    # -------Upper and lower bounds for design variables-------------- 
    OPT.LB_macro, OPT.UB_macro = 0, 1.0   # Lower and upper bounds for MACRO scale   
    # -----------------------------------------------
    tol = FE.max_elem_side / 1000
    
    # Compute filter radius and search distance
    filter_radius = OPT.parameters.filter_radius_factor * (FE.max_elem_side)
    search_dist = filter_radius - tol
    # Build BallTree for nearest neighbor search
    balltree = BallTree(FE.centroids)
    OPT_H = zeros(FE.n_elem, FE.n_elem)
    # Loop over elements
    for iel in 1:FE.n_elem
        near_ele = inrange(balltree, FE.centroids[:, iel], search_dist)
        dist = sqrt.(sum((FE.centroids[:, near_ele] .- FE.centroids[:, iel]) .^ 2, dims=1))
        num = 1 .- dist ./ OPT.filter_radius
        den = sum(num)
        OPT_H[iel, near_ele] = num / den
    end
    # Create sparse matrix
    OPT.H = sparse(OPT_H)
    # ==========Initialization of Design variable in MTOP======================
    # Initialize values of dv
    OPT.n_dv = FE.n_elem
    OPT.index_dv_macro = vec(1:FE.n_elem)
    if OPT.fd_check == true
        OPT.dv = vec(OPT.LB_macro .+ rand(FE.n_elem, 1) .* (OPT.UB_macro .- OPT.LB_macro))
    else
        OPT.dv = vec(OPT.parameters.init_dens_macro * ones(FE.n_elem, 1))
    end
    # =================================================================
    OPT.grad_stress_fatigue = zeros(FE.n_elem)  
    OPT.grad_volume_fraction = zeros(FE.n_elem)  
    FE.svm = zeros(FE.n_elem, FE.nloads)
    return OPT, FE
end