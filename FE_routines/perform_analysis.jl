function perform_analysis(OPT::OPT_struct, FE::FE_struct)
    OPT, FE = FE_compute_element_stiffness(OPT::OPT_struct, FE::FE_struct) # !!! UPDATE stiffness matrix !!!
    FE = FE_analysis(OPT::OPT_struct, FE::FE_struct)
    return OPT, FE

end
