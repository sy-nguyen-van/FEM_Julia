include("relaxdens.jl")
function maximum_stress(OPT, FE)
    # --------------------------------------------------------------
    # Compute element von Mises stress for each load case
    # --------------------------------------------------------------
    se = zeros(FE.n_elem, FE.nloads)

    V = FE.V
    rhomin = FE.material.rho_min

    for iload in 1:FE.nloads
        Ul = FE.U[:, iload]
        for j in 1:FE.n_elem
            e_dof = Int.(FE.edofMat[j, :])
            Ue = Ul[e_dof]
            Ce = FE.Ce[:, :, j] # Constitute matrix
            B0e = FE.B0e[:, :, j]
            sigma = Ce * B0e * Ue
            se[j, iload] = sqrt(sigma' * V * sigma)
        end
    end

    # --------------------------------------------------------------
    # Relaxed stress
    # --------------------------------------------------------------
    p = 3.0
    q = 2.5
    slim = OPT.functions.stress_limit

    re, dredrhof = relaxdens(OPT.filt_rho_e, p, q, rhomin, "stdpq")

    FE.svm = re .* se

    # --------------------------------------------------------------
    # Aggregation type
    # --------------------------------------------------------------

    h = FE.svm ./ slim
    dhds = ones(size(h)) ./ slim
    phi = h
    dphidh = ones(size(h))

    P = OPT.aggregation_power
    g = sum(vec(phi) .^ P)^(1 / P)
    dgdphi_vec = (vec(phi) ./ P) .^ (P - 1)

    dgdphi = reshape(dgdphi_vec, size(h))

    g = g - 1   # shift

    # --------------------------------------------------------------
    # Pseudo-load
    # --------------------------------------------------------------
    FE.dJdu = zeros(FE.n_global_dof, FE.nloads)

    for iload in 1:FE.nloads
        Ul = FE.U[:, iload]

        for j in 1:FE.n_elem
            e_dof = Int.(FE.edofMat[j, :])
            Ue = Ul[e_dof]
            B0e = FE.B0e[:, :, j]
             Ce = FE.Ce[:, :, j] # Constitute matrix
            sigma = Ce * B0e * Ue
            MeUe = B0e' * C * V * sigma

            FE.dJdu[e_dof, iload] = FE.dJdu[e_dof, iload] -      dgdphi[j, iload] * dphidh[j, iload] * dhds[j, iload] * (FE.svm[j, iload] / se[j, iload]^2) * MeUe
        end
    end

    # --------------------------------------------------------------
    # Solve pseudo-adjoint system
    # --------------------------------------------------------------
    FE = FE_solve("adjoint", FE)

    # --------------------------------------------------------------
    # Sensitivity computation
    # --------------------------------------------------------------
    lTdku = zeros(FE.n_elem, FE.nloads)

    for iload in 1:FE.nloads
        Ul = FE.U[:, iload]
        Ll = FE.lambda[:, iload]
        for j in 1:FE.n_elem
             e_dof = Int.(FE.edofMat[j, :])
            Ue = Ul[e_dof]
            Le = Ll[e_dof]
            dKe = OPT.dpen_rho_e[j] * FE.Ke[:, :, j]
            lTdku[j, iload] = Le' * dKe * Ue
        end
    end

    grad_g = zeros(FE.n_elem)

    for iload in 1:FE.nloads
        grad_g .+=
            dgdphi[:, iload] .* dphidh[:, iload] .* dhds[:, iload] .* dredrhof .* se[:, iload] .+
            lTdku[:, iload]
    end

    # Apply filtering
    grad_g = OPT.H' * grad_g

    # --------------------------------------------------------------
    # Save results
    # --------------------------------------------------------------
    OPT.approx_h_max = g + 1
    OPT.true_h_max = maximum(h)
    OPT.true_stress_fatigue_max = maximum(FE.svm) # Vector with as many components as load cases
    OPT.grad_stress_fatigue = grad_g


    return g, grad_g
end