function FE_init_partitioning(FE::FE_struct)
    # Total DOFs
    FE.n_global_dof = FE.dim * FE.n_node

    # Fixed DOFs vector
    FE.fixeddofs = zeros(Int, FE.n_global_dof)
    
    # Prescribed BCs
    if FE.dim == 2
        FE.fixeddofs[2 * FE.BC.disp_node[FE.BC.disp_dof .== 1] .- 1] .= 1 # x DOFs
        FE.fixeddofs[2 * FE.BC.disp_node[FE.BC.disp_dof .== 2]] .= 1      # y DOFs
    elseif FE.dim == 3
        FE.fixeddofs[3 * FE.BC.disp_node[FE.BC.disp_dof .== 1] .- 2] .= 1 # x DOFs
        FE.fixeddofs[3 * FE.BC.disp_node[FE.BC.disp_dof .== 2] .- 1] .= 1 # y DOFs
        FE.fixeddofs[3 * FE.BC.disp_node[FE.BC.disp_dof .== 3]] .= 1      # z DOFs
    end

    FE.freedofs = .!(FE.fixeddofs .== 1)
    FE.fixeddofs_ind = findall(FE.fixeddofs .== 1)
    FE.freedofs_ind = findall(FE.freedofs .== 1)
    FE.n_free_dof = length(FE.freedofs_ind)

    # Compute DOFs per element based on element type
    n_elem_dof_vec = Int[]
    for e in 1:FE.n_elem
        el_type = FE.elem_type[e]
        nen = sum(FE.elem_node[:, e] .!= 0)
        dim = el_type in (:CPS3, :Quad4) ? 2 : 3
        n_elem_dof = nen * dim
        push!(n_elem_dof_vec, n_elem_dof)
    end
    FE.n_edof = maximum(n_elem_dof_vec)  # for allocation

    # edofMat: each row corresponds to element DOFs
    FE.edofMat = zeros(Int, FE.n_elem, FE.n_edof)

    for e in 1:FE.n_elem
        enodes = FE.elem_node[:, e]

        el_type = FE.elem_type[e]
        dim = el_type in (:CPS3, :Quad4) ? 2 : 3
        nen = length(enodes)

        if FE.dim == 2
            edofs = reshape(transpose(hcat(2 * enodes .- 1, 2 * enodes)), 1, nen*dim)
        elseif FE.dim == 3
            edofs = reshape(transpose(hcat(3 * enodes .- 2, 3 * enodes .- 1, 3 * enodes)), 1, nen*dim)
        end

        # store in edofMat, pad with zeros if needed
        FE.edofMat[e, :] = edofs
    end

    # iK, jK for vectorized assembly
    FE.iK = vec(Int.(reshape(transpose(FE.edofMat ⊗ ones(FE.n_edof, 1)), FE.n_edof^2 * FE.n_elem, 1)))
    FE.jK = vec(Int.(reshape(transpose(FE.edofMat ⊗ ones(1, FE.n_edof)), FE.n_edof^2 * FE.n_elem, 1)))

    return FE
end
