function FE_analysis(OPT::OPT_struct, FE::FE_struct)
    #
    # Assemble the global stiffness matrix and solve the finite element
    # analysis
    # assemble the stiffness matrix partitions Kpp Kpf Kff
    FE = FE_assemble_stiffness_matrix(OPT::OPT_struct, FE::FE_struct)

    # solve the displacements and reaction forces
    FE = FE_solve("primal", FE::FE_struct)

    return FE
end