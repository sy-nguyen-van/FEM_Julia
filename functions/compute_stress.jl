function compute_stress(FE::FE_struct)
    sig_vm = zeros(FE.n_elem, FE.nloads)  # Preallocate
    
    for iload in 1:FE.nloads
        U_global = FE.U[:, iload]  # Global displacement vector
        
        for e in 1:FE.n_elem
            e_dof = Int.(FE.edofMat[e, :])
            Ce = FE.Ce[:, :, e]       # Constitutive matrix
            Be = FE.B0e[:, :, e]      # Strain-displacement matrix
            Ue = U_global[e_dof]      # Element displacement
            
            # Element stress
            sigma_e = Ce * Be * Ue
            
            # Von Mises stress
            # If FE.V is scalar per element
            sig_vm[e, iload] = sqrt(transpose(sigma_e) * FE.V* sigma_e)
        end
    end
    
    FE.svm = sig_vm
    return FE
end
