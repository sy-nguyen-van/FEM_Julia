function Ke_Ce_Update!(FE_Ce, FE_Ke, FE_B0e, 
    FE_n_elem, FE_dim, FE_material_E, FE_material_nu, FE_coords, FE_elem_node)

    # Gauss quadrature for quad/hex
    gauss_pt = [-1 1] / sqrt(3)
    W = [1 1]
    num_gauss_pt = length(gauss_pt)

    # Gauss quadrature for tri (single point, area coordinates)
    gauss_tri = [1/3 1/3]  # Centroid
    W_tri = 0.5  # Weight for triangle (area = 1/2)

    # Gauss quadrature for tet (single point, volume coordinates)
    gauss_tet = [1/4 1/4 1/4]  # Centroid
    W_tet = 1/6  # Weight for tetrahedron (volume = 1/6)

    for e in 1:FE_n_elem
        num_nodes = size(FE_elem_node, 2) - sum(FE_elem_node[e, :] .== 0)  # Count non-zero nodes
        Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
        FE_Ce[:, :, e] = Ce

        if FE_dim == 2
            if num_nodes == 3  # 3-node triangle
                xi, eta = gauss_tri
                # Compute Jacobian
                J = Jacobian3(xi, eta, e, FE_coords, FE_elem_node)
                det_J = det(J)
                inv_J = J \ I(size(J, 1))
                # Shape function derivatives
                GN = inv_J * G0_N3(xi, eta, e)
                # B matrix for 3-node triangle (2 DOF per node)
                B = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0;
                     0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3];
                     GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3]]
                FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W_tri * det_J * B' * Ce * B

                # B0 at centroid
                J0 = Jacobian3(0, 0, e, FE_coords, FE_elem_node)
                inv_J0 = J0 \ I(size(J0, 1))
                GN = inv_J0 * G0_N3(0, 0, e)
                B0 = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0;
                      0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3];
                      GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3]]
                FE_B0e[:, :, e] = B0

            elseif num_nodes == 4  # 4-node quad
                for i in 1:num_gauss_pt
                    xi = gauss_pt[i]
                    for j in 1:num_gauss_pt
                        eta = gauss_pt[j]
                        J = Jacobian(xi, eta, e, FE_coords, FE_elem_node)
                        det_J = det(J)
                        inv_J = J \ I(size(J, 1))
                        GN = inv_J * G0_N(xi, eta, e)
                        B = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0 GN[1, 4] 0;
                             0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3] 0 GN[2, 4];
                             GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3] GN[2, 4] GN[1, 4]]
                        FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W[i] * W[j] * det_J * B' * Ce * B
                    end
                end
                J0 = Jacobian(0, 0, e, FE_coords, FE_elem_node)
                inv_J0 = J0 \ I(size(J0, 1))
                GN = inv_J0 * G0_N(0, 0, e)
                B0 = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0 GN[1, 4] 0;
                      0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3] 0 GN[2, 4];
                      GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3] GN[2, 4] GN[1, 4]]
                FE_B0e[:, :, e] = B0
            end

        else  # FE_dim == 3
            if num_nodes == 4  # 4-node tetrahedron
                xi, eta, zeta = gauss_tet
                J = Jacobian4(xi, eta, zeta, e, FE_coords, FE_elem_node)
                det_J = det(J)
                inv_J = J \ I(size(J, 1))
                GN = inv_J * G0_N4(xi, eta, zeta, e)
                # B matrix for 4-node tet (3 DOF per node)
                B = [GN[1, 1] 0 0 GN[1, 2] 0 0 GN[1, 3] 0 0 GN[1, 4] 0 0;
                     0 GN[2, 1] 0 0 GN[2, 2] 0 0 GN[2, 3] 0 0 GN[2, 4] 0;
                     0 0 GN[3, 1] 0 0 GN[3, 2] 0 0 GN[3, 3] 0 0 GN[3, 4];
                     GN[2, 1] GN[1, 1] 0 GN[2, 2] GN[1, 2] 0 GN[2, 3] GN[1, 3] 0 GN[2, 4] GN[1, 4] 0;
                     0 GN[3, 1] GN[2, 1] 0 GN[3, 2] GN[2, 2] 0 GN[3, 3] GN[2, 3] 0 GN[3, 4] GN[2, 4];
                     GN[3, 1] 0 GN[1, 1] GN[3, 2] 0 GN[1, 2] GN[3, 3] 0 GN[1, 3] GN[3, 4] 0 GN[1, 4]]
                FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W_tet * det_J * B' * Ce * B

                # B0 at centroid
                J0 = Jacobian4(0, 0, 0, e, FE_coords, FE_elem_node)
                inv_J0 = J0 \ I(size(J0, 1))
                GN = inv_J0 * G0_N4(0, 0, 0, e)
                B0 = [GN[1, 1] 0 0 GN[1, 2] 0 0 GN[1, 3] 0 0 GN[1, 4] 0 0;
                      0 GN[2, 1] 0 0 GN[2, 2] 0 0 GN[2, 3] 0 0 GN[2, 4] 0;
                      0 0 GN[3, 1] 0 0 GN[3, 2] 0 0 GN[3, 3] 0 0 GN[3, 4];
                      GN[2, 1] GN[1, 1] 0 GN[2, 2] GN[1, 2] 0 GN[2, 3] GN[1, 3] 0 GN[2, 4] GN[1, 4] 0;
                      0 GN[3, 1] GN[2, 1] 0 GN[3, 2] GN[2, 2] 0 GN[3, 3] GN[2, 3] 0 GN[3, 4] GN[2, 4];
                      GN[3, 1] 0 GN[1, 1] GN[3, 2] 0 GN[1, 2] GN[3, 3] 0 GN[1, 3] GN[3, 4] 0 GN[1, 4]]
                FE_B0e[:, :, e] = B0

            elseif num_nodes == 8  # 8-node hex
                for i in 1:num_gauss_pt
                    xi = gauss_pt[i]
                    for j in 1:num_gauss_pt
                        eta = gauss_pt[j]
                        for k in 1:num_gauss_pt
                            zeta = gauss_pt[k]
                            J = Jacobian8(xi, eta, zeta, e, FE_coords, FE_elem_node)
                            det_J = det(J)
                            inv_J = J \ I(size(J, 1))
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
            end
        end
    end

    nothing
end