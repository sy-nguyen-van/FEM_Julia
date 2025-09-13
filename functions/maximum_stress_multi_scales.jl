
function maximum_stress_multi_scales(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct)
    P_norm = OPT.aggregation_power
    #------------------------------------------------
    sig_vm = zeros(FE.n_elem, FE.nloads)
    sig_r = zeros(FE.n_elem, FE.nloads)
    xx3 = zeros(FE.n_elem, FE.nloads)
    #------------Penalization of stress---------------------
    relax_power = OPT.relax_power
    rho_q = real((OPT.filt_rho_e) .^ (relax_power))
    d_rho_q = (relax_power) * ((OPT.filt_rho_e) .^ (relax_power - 1))

    # =============3D-P-NORM=========================
    F_adjoint = zeros(FE.n_global_dof, FE.nloads) # Struct for adjoint forces  

    F_adjoint, sig_vm, sig_r, xx3 = F_adjoint_stress_multi_scales(FE, F_adjoint, sig_vm, sig_r, xx3, rho_q, P_norm)

    # =================== Compute sig_vm sensitivities ===========================
    slim = OPT.functions.stress_limit
    FE.svm = sig_r
    sig_r_new = reshape(sig_r ./ slim', FE.nloads * FE.n_elem, 1)
    g = sum(sig_r_new .^ P_norm) .^ (1 / P_norm) ### Constraint!!!!!!!!!!!!!!!!!!!!!!!!
    adj_2 = sum(sig_r_new .^ P_norm) .^ (1 / P_norm - 1)
    # Solve pseudo analysis to compute adjoint solution
    FE.dJdu = -adj_2 * F_adjoint
    # Solve Lambda
    FE = FE_solve("adjoint", FE)
    #-----------------------------------------------------------------------
    grad_g_rho_k = zeros(FE.n_elem, 1) # Gradient for macro density
    grad_g_t_k = zeros(FE.n_elem, 1) # Gradient for micro thickness
    grad_g_rho_k, grad_g_t_k = grad_g_stress_multi_scales(grad_g_rho_k, grad_g_t_k, FE, OPT, adj_2, slim, sig_vm, sig_r, xx3,rho_q, d_rho_q, P_norm)

    # Account for filtering in sensitivities
    if OPT.functions.objective == "maximum_stress_multi_scales"
        h = FE.svm
        grad_g_rho_k = transpose(OPT.H) * ((grad_g_rho_k[:] .* OPT.diff_Hea[:]))
        grad_g_t_k = transpose(OPT.H) * (grad_g_t_k[:])
    else
        g = g .- 1
        h = sig_r ./ slim'
        grad_g_rho_k = transpose(OPT.H) * ((grad_g_rho_k[:] .* OPT.diff_Hea[:]))
        grad_g_t_k = transpose(OPT.H) * (grad_g_t_k[:])
    end
    grad_g = [grad_g_rho_k; grad_g_t_k]
    # save these values in the OPT structure
    OPT.approx_h_max = g .+ 1
    OPT.true_h_max = maximum(h)
    OPT.true_stress_fatigue_max = maximum(FE.svm) # Vector with as many components as load cases
    OPT.grad_stress_fatigue = grad_g

    return g, grad_g
end
