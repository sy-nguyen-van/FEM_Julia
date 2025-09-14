function compliance(OPT::OPT_struct, FE::FE_struct)
    #
    # This function computes the mean compliance and its sensitivities
    # based on the last finite element analysis
    #
    ## =======================================================
    # # compute the compliance
    c = dot(FE.U, FE.P)
    # compute the design sensitivity
    Ke = FE.Ke
    dKe = FE.dKe  # !!!!!!!!!
    Ue = permutedims(
        repeat(transpose(FE.U[Int.(FE.edofMat)]), 1, 1, FE.n_edof)
        , [1, 3, 2])
    Ue_trans = permutedims(Ue, [2, 1, 3])

    grad_c_ = reshape(sum(
            sum(- Ue_trans .* (dKe .* Ue), dims=1), dims=2), 1, FE.n_elem)
    ## =======================================================

    grad_c = transpose(OPT.H) * (grad_c_[:])
    #----------------------

    # save these values in the OPT structure
    OPT.compliance = c
    OPT.grad_compliance = grad_c
    return c, grad_c, OPT
end