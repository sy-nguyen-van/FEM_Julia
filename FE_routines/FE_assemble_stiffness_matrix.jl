function FE_assemble_stiffness_matrix(OPT::OPT_struct, FE::FE_struct)
    # FE_ASSEMBLE assembles the global stiffness matrix, partitions it by 
    # prescribed and free dofs, and saves the known partitions in the FE structure.

    ## Declare global variables

    ## assemble and partition the global stiffness matrix

    penalized_rho_e = permutedims(
        repeat(OPT.pen_rho_e[:], 1, FE.n_edof, FE.n_edof), [2, 3, 1])

    # Ersatz material: 
    penalized_Ke = penalized_rho_e .* FE.Ke
    FE.sK_penal = penalized_Ke[:]

    # FE.sK_penal = FE.Ke[:]

    # assemble the penalized global stiffness matrix (the sparse functions
    # accumulates values with repeated indices, which allows to assemble the
    # global stiffness matrix simply with this line).

    K = sparse(vec(Int.(FE.iK)), vec(Int.(FE.jK)), FE.sK_penal)

    K = (K .+ transpose(K)) / 2

    # partition the stiffness matrix and return these partitions to FE
    FE.Kpp = K[FE.fixeddofs_ind, FE.fixeddofs_ind]
    FE.Kfp = K[FE.freedofs_ind, FE.fixeddofs_ind]
    # note: by symmetry Kpf = Kfp', so we don't store Kpf. Tall and thin
    # matrices are stored more efficiently as sparse matrices, and since we
    # generally have more free dofs than fixed, we choose to store the rows as
    # free dofs to save on memory.
    FE.Kff = K[FE.freedofs_ind, FE.freedofs_ind]
    return FE

end