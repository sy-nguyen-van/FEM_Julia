function obj_nonlcon(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct, dv)
    OPT.dv_old = copy(OPT.dv) # save the previous design
    OPT.dv = copy(dv) # update the design
    # Update or perform the analysis only if design has changed
    OPT, FE = perform_analysis(OPT, FE)
    #-------------------------------
    f0val, df0dx = eval(Symbol(OPT.functions.objective))(OPT, FE,SGs)
    fval, dfdx = eval(Symbol(OPT.functions.constraints))(OPT, FE,SGs)
    
    if OPT.functions.constraints == "volume_fraction" || OPT.functions.constraints == "volume_fraction_multi_scales"
        fval = copy(fval) - OPT.functions.volume_fraction_limit
    end

    return f0val, df0dx, fval, dfdx, OPT, FE
end