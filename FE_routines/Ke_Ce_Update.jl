function Ke_Ce_Update!(FE_Ce, FE_Ke, FE_B0e,
    FE_n_elem, FE_dim, FE_material_E, FE_material_nu, FE_coords, FE_elem_node)

    gauss_pt = [-1 1] / sqrt(3)
    W = [1 1 1]
    num_gauss_pt = length(gauss_pt)
    # determine nodes per element from FE_elem_node shape:
    nodes_per_elem = size(FE_elem_node, 1)

    for e in 1:FE_n_elem
        if FE_dim == 2
            if nodes_per_elem == 3
                # 3-node triangle (constant B, single integration)
                Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
                FE_Ce[:, :, e] = Ce
                B, area = Be_Area(Val(:CPS3), e, FE_coords, FE_elem_node)
                FE_Ke[:, :, e] = area * (B' * Ce * B)
                FE_B0e[:, :, e] = B  # constant over element

            elseif nodes_per_elem == 4
                # 4-node quad (existing code)
                Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
                FE_Ce[:, :, e] = Ce
                #--------------------------------------------------------
                # Voigt matrix for von Mises stress computation
                # loop over Gauss Points
                for i in 1:num_gauss_pt
                    xi = gauss_pt[i]
                    for j in 1:num_gauss_pt
                        eta = gauss_pt[j]
                        # Compute Jacobian
                        J = Jacobian(xi, eta, e, FE_coords, FE_elem_node)
                        det_J = det(J)
                        inv_J = J \ I(size(J, 1))
                        # Compute shape function derivatives (strain displacement matrix)
                        GN = inv_J * G0_N(xi, eta, e)
                        B = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0 GN[1, 4] 0;
                            0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3] 0 GN[2, 4];
                            GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3] GN[2, 4] GN[1, 4]]
                        FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W[i] * W[j] * det_J * B' * Ce * B
                    end
                end
                J0 = Jacobian(0, 0, e, FE_coords, FE_elem_node)
                inv_J0 = J0 \ I(size(J0, 1))

                GN = inv_J0 * G0_N(0, 0, e) # Shape function gradient at element centroid
                B0 = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0 GN[1, 4] 0;
                    0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3] 0 GN[2, 4];
                    GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3] GN[2, 4] GN[1, 4]]
                FE_B0e[:, :, e] = B0

            else
                error("Unsupported nodes_per_elem = $nodes_per_elem for 2D (only 3 or 4 supported).")
            end

        elseif FE_dim == 3
            if nodes_per_elem == 4
                # 4-node tetra (constant B)
                Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
                FE_Ce[:, :, e] = Ce
                B, volume = Be_Area(Val(:Tet4), e, FE_coords, FE_elem_node)
                FE_Ke[:, :, e] = volume * (B' * Ce * B)
                FE_B0e[:, :, e] = B  # constant over element

            elseif nodes_per_elem == 8
                # 8-node hex (existing code)
                Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
                FE_Ce[:, :, e] = Ce
                #         loop over Gauss Points
                for i in 1:num_gauss_pt
                    xi = gauss_pt[i]
                    for j in 1:num_gauss_pt
                        eta = gauss_pt[j]
                        for k in 1:num_gauss_pt
                            zeta = gauss_pt[k]
                            # Compute Jacobian
                            J = Jacobian8(xi, eta, zeta, e, FE_coords, FE_elem_node)
                            det_J = det(J)
                            inv_J = J \ I(size(J, 1))
                            # Compute shape function derivatives (strain displacement matrix)
                            GN = inv_J * G0_N8(xi, eta, zeta, e)
                            B = [GN[1, 1] 0 0 GN[1, 2] 0 0 GN[1, 3] 0 0 GN[1, 4] 0 0 GN[1, 5] 0 0 GN[1, 6] 0 0 GN[1, 7] 0 0 GN[1, 8] 0 0;
                                0 GN[2, 1] 0 0 GN[2, 2] 0 0 GN[2, 3] 0 0 GN[2, 4] 0 0 GN[2, 5] 0 0 GN[2, 6] 0 0 GN[2, 7] 0 0 GN[2, 8] 0;
                                0 0 GN[3, 1] 0 0 GN[3, 2] 0 0 GN[3, 3] 0 0 GN[3, 4] 0 0 GN[3, 5] 0 0 GN[3, 6] 0 0 GN[3, 7] 0 0 GN[3, 8];
                                GN[2, 1] GN[1, 1] 0 GN[2, 2] GN[1, 2] 0 GN[2, 3] GN[1, 3] 0 GN[2, 4] GN[1, 4] 0 GN[2, 5] GN[1, 5] 0 GN[2, 6] GN[1, 6] 0 GN[2, 7] GN[1, 7] 0 GN[2, 8] GN[1, 8] 0;
                                0 GN[3, 1] GN[2, 1] 0 GN[3, 2] GN[2, 2] 0 GN[3, 3] GN[2, 3] 0 GN[3, 4] GN[2, 4] 0 GN[3, 5] GN[2, 5] 0 GN[3, 6] GN[2, 6] 0 GN[3, 7] GN[2, 7] 0 GN[3, 8] GN[2, 8];
                                GN[3, 1] 0 GN[1, 1] GN[3, 2] 0 GN[1, 2] GN[3, 3] 0 GN[1, 3] GN[3, 4] 0 GN[1, 4] GN[3, 5] 0 GN[1, 5] GN[3, 6] 0 GN[1, 6] GN[3, 7] 0 GN[1, 7] GN[3, 8] 0 GN[1, 8]]
                            FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W[i] * W[j] * W[k] * det_J * B' * Ce * B
                        end
                    end
                end
                J0 = Jacobian8(0, 0, 0, e, FE_coords, FE_elem_node)
                inv_J0 = J0 \ I(size(J0, 1))
                GN = inv_J0 * G0_N8(0, 0, 0, e)
                B0 = [GN[1, 1] 0 0 GN[1, 2] 0 0 GN[1, 3] 0 0 GN[1, 4] 0 0 GN[1, 5] 0 0 GN[1, 6] 0 0 GN[1, 7] 0 0 GN[1, 8] 0 0;
                    0 GN[2, 1] 0 0 GN[2, 2] 0 0 GN[2, 3] 0 0 GN[2, 4] 0 0 GN[2, 5] 0 0 GN[2, 6] 0 0 GN[2, 7] 0 0 GN[2, 8] 0;
                    0 0 GN[3, 1] 0 0 GN[3, 2] 0 0 GN[3, 3] 0 0 GN[3, 4] 0 0 GN[3, 5] 0 0 GN[3, 6] 0 0 GN[3, 7] 0 0 GN[3, 8];
                    GN[2, 1] GN[1, 1] 0 GN[2, 2] GN[1, 2] 0 GN[2, 3] GN[1, 3] 0 GN[2, 4] GN[1, 4] 0 GN[2, 5] GN[1, 5] 0 GN[2, 6] GN[1, 6] 0 GN[2, 7] GN[1, 7] 0 GN[2, 8] GN[1, 8] 0;
                    0 GN[3, 1] GN[2, 1] 0 GN[3, 2] GN[2, 2] 0 GN[3, 3] GN[2, 3] 0 GN[3, 4] GN[2, 4] 0 GN[3, 5] GN[2, 5] 0 GN[3, 6] GN[2, 6] 0 GN[3, 7] GN[2, 7] 0 GN[3, 8] GN[2, 8];
                    GN[3, 1] 0 GN[1, 1] GN[3, 2] 0 GN[1, 2] GN[3, 3] 0 GN[1, 3] GN[3, 4] 0 GN[1, 4] GN[3, 5] 0 GN[1, 5] GN[3, 6] 0 GN[1, 6] GN[3, 7] 0 GN[1, 7] GN[3, 8] 0 GN[1, 8]]
                FE_B0e[:, :, e] = B0
            else
                error("Unsupported nodes_per_elem = $nodes_per_elem for 3D (only 4 or 8 supported).")
            end
        end
    end

    nothing
end
