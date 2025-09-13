function volume_fraction(OPT, FE, SGs)
    #
    # This function computes the volume fraction and its sensitivities
    # based on the last geometry projection
    #
    # compute the volume fraction
    V = FE.n_elem # total volume
    v_e = sum(OPT.dv_micro[:]/OPT.rho_thick) # element volumes
    vf = v_e / V
    # compute the design sensitivity
    grad_vf = vec(transpose(OPT.H) * (ones(FE.n_elem, 1)/ V))/OPT.rho_thick
    #----------------------------------
    # output
    OPT.volume_fraction = vf 
    OPT.grad_volume_fraction = grad_vf
    return vf, grad_vf

end