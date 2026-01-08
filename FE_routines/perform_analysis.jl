function perform_analysis(OPT::OPT_struct, FE::FE_struct)
    OPT, FE = FE_compute_element_stiffness(OPT::OPT_struct, FE::FE_struct) # !!! UPDATE stiffness matrix !!!

    dv_macro = OPT.H * OPT.dv
    
    coeff = OPT.beta_min .+ OPT.iter * ((OPT.beta_max - OPT.beta_min) / OPT.options.max_iter)
    filt_rho_e, diff_Hea = Heaviside(dv_macro, coeff, OPT.eta_H)
    OPT.filt_rho_e = copy(filt_rho_e)
    OPT.diff_Hea = copy(diff_Hea)
    # Penalize densities
    pen_rho_e, dpen_rho_e = penalize(OPT::OPT_struct, FE::FE_struct)
    OPT.pen_rho_e = copy(pen_rho_e)
    OPT.dpen_rho_e = copy(dpen_rho_e)


    FE = FE_analysis(OPT::OPT_struct, FE::FE_struct)

    return OPT, FE

end
