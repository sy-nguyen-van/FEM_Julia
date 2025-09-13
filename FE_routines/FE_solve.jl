

function FE_solve(type, FE::FE_struct)
    #
    # This function solves the system of linear equations arising from the
    # finite element discretization of Eq. (17).  It stores the displacement 
    # and the reaction forces in FE.U and FE.P.
    # 
    # type is either "primal" or "adjoint"

    p = FE.fixeddofs_ind
    f = FE.freedofs_ind

    primal = lowercase(type) == "primal"
    adjoint = lowercase(type) == "adjoint"
    if !primal && !adjoint
        println("Unrecognized FE analysis type.")
    end

    # save the system RHS
    if primal
        FE.rhs = FE.P[f, :] - FE.Kfp * FE.U[p, :]
    elseif adjoint
        FE_prhs = FE.dJdu[f, :]
        FE.lambda = zeros(FE.n_global_dof, FE.nloads)
    end

    if primal
        # Cholesky factorization; store the factor for sensitivity analysis
        # FE.R = cholesky(FE.Kff)
        # FE.U[f, :] = FE.R \ FE.rhs
        FE.R = factorize(Symmetric(FE.Kff))
        FE.U[f, :] = FE.R\FE.rhs
        # Solve the linear system
        # Solve for the primal solution        
    elseif adjoint
        # Use Cholesky factorization from prior primal analysis
        FE.lambda[f, :] = FE.R \ FE_prhs
    end

    # Compute reaction forces
    if primal
        FE.P[p, :] = FE.Kpp * FE.U[p, :] + transpose(FE.Kfp) * FE.U[f, :]
    end

    return FE
end