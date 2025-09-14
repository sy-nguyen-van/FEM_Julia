function get_inputs(OPT::OPT_struct, FE::FE_struct)
    OPT, FE  = eval(Symbol("inputs_"*OPT.examples))(OPT, FE)
    return OPT, FE
end