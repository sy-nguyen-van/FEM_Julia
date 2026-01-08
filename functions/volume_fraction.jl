function volume_fraction(OPT, FE)
    #
    # This function computes the volume fraction and its sensitivities
    # based on the last geometry projection
    #
    # compute the volume fraction
    v_e = FE.elem_vol; # element volumes
    V = sum(v_e); # total volume
    vf_e0 = v_e/V;
    vf_e = vf_e0 .* OPT.filt_rho_e[:]; 
    vf =  sum(vf_e); 
    # compute the design sensitivity
    grad_vf = vec(transpose(OPT.H) * (vf_e0))
    #----------------------------------
    # output
    OPT.volume_fraction = vf 
    OPT.grad_volume_fraction = grad_vf
    return vf, grad_vf

end