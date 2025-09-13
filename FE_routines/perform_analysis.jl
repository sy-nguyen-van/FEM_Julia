include("Heaviside.jl")
include("penalize.jl")
include("FE_assemble_stiffness_matrix.jl")

function perform_analysis(OPT::OPT_struct, FE::FE_struct)
    #
    # Filter and penalize densities, solve the finite
    # element problem for the displacements and reaction forces, and then
    # evaluate the relevant functions.
    #-------------------------
    OPT, FE = FE_compute_element_stiffness(OPT::OPT_struct, FE::FE_struct) # !!! UPDATE stiffness matrix !!!
    #-------------------------
    if OPT.run_multi_scales == true
        # Filter densities
        dv_macro = OPT.H * OPT.dv[OPT.index_dv_macro]
        coeff = OPT.beta_min .+ OPT.iter * ((OPT.beta_max - OPT.beta_min) / OPT.options.max_iter)
        filt_rho_e, diff_Hea = Heaviside(dv_macro, coeff, OPT.eta_H)
        OPT.filt_rho_e =  copy(filt_rho_e)
        OPT.diff_Hea = copy(diff_Hea)
        # Penalize densities
        pen_rho_e, dpen_rho_e = penalize(OPT::OPT_struct, FE::FE_struct)
        OPT.pen_rho_e = copy(pen_rho_e)
        OPT.dpen_rho_e = copy(dpen_rho_e)
        # Perform FE analysis
    end
    FE = FE_analysis(OPT::OPT_struct, FE::FE_struct)

    return OPT, FE

end
