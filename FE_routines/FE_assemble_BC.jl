function FE_assemble_BC(FE::FE_struct)
  #
  # FE_ASSEMBLE_BC assembles the boundary conditions; the known portions of 
  # the load vector and displacement vector.

  ## Reads: 
  #           FE.
  #           n_global_dof
  #           dim
  #           BC

  ## Writes:
  #           FE.
  #           U
  #           P

  ## Declare global variables


  ## Assemble prescribed displacements

  # inititialize a sparse global displacement vector
  FE.U = zeros(FE.n_global_dof, FE.nloads)

  # determine prescribed xi displacement components:
  for idisp in 1:FE.BC.n_pre_disp_dofs
    idx = FE.dim * (FE.BC.disp_node[idisp] - 1) .+ FE.BC.disp_dof[idisp]
    FE.U[Int.(idx), :] .= FE.BC.disp_value[idisp]
  end


  ## Assemble prescribed loads

  # initialize a sparse global force vector
  FE.P = spzeros(FE.n_global_dof, FE.nloads)

  # determine prescribed xi load components:
  s = 0
  for icase in 1:Int(FE.nloads)
    for iload in 1:Int(FE.BC.n_pre_force_dofs[icase])
      idx = FE.dim * (FE.BC.force_node[iload+s] .- 1) .+ FE.BC.force_dof[iload+s]
      FE.P[Int(idx), icase] = FE.BC.force_value[iload + s]
    end
    s = Int(FE.BC.n_pre_force_dofs[icase])
  end
  return FE
end