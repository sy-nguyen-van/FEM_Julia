
function obj(OPT::OPT_struct, FE::FE_struct, dv)

    OPT.dv_old = copy(OPT.dv) # save the previous design
    OPT.dv = copy(dv) # update the design

    # Update or perform the analysis only if design has changed
    OPT, FE = perform_analysis(OPT, FE)
    #-------------------------------
    # Dynamically call the function using eval
    f, gradf = eval(Symbol(OPT.functions.objective))(OPT, FE)

    return f, gradf, OPT, FE
end