function penalize(OPT::OPT_struct, FE::FE_struct)

    #     The optional third argument is a string that indicates the way the 
    #	  interpolation is defined, possible values are:
    #       'SIMP'      : default 
    # 	  	'RAMP'      : 
    #       'modified_SIMP' : uses xmin as lower bound
    #       'modified_RAMP' : uses xmin as lower bound
    x = OPT.filt_rho_e
    p = OPT.parameters.penalization_param
    penal_scheme = OPT.parameters.penalization_scheme
    xmin = FE.material.rho_min

    # define function
    if penal_scheme == "SIMP"
        P = x .^ p
        dPdx = p * x .^ (p - 1)
    elseif penal_scheme == "RAMP"
        P = x ./ (1 + p .* (1 .- x))
        dPdx = (1 + p) ./ (1 + p .* (1 .- x)) .^ 2
    elseif penal_scheme == "modified_SIMP"
        P = xmin .+ x .^ p * (1 - xmin)
        dPdx = (1 .- xmin) * p * x .^ (p - 1)
    elseif penal_scheme == "modified_RAMP"
        P = xmin + x ./ (1 + p .* (1 .- x)) * (1 - xmin)
        dPdx = (1 - xmin) * ((1 + p) ./ (1 + p .* (1 .- x)) .^ 2)
    end

    return P, dPdx
end