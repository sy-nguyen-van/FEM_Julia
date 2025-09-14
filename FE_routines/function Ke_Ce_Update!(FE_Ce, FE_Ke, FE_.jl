function Ke_Ce_Update!(FE_Ce, FE_Ke, FE_B0e,
    FE_n_elem, FE_dim, FE_material_E, FE_material_nu, FE_coords, FE_elem_node)

    gauss_pt = [-1 1] / sqrt(3)
    W = [1 1 1]
    num_gauss_pt = length(gauss_pt)

    # helper: linear tri (3-node) -> returns B (3x6) and area (scalar)
    tri_B_area = function(e)
        # node ids of element e (assumes FE_elem_node is nodes_per_elem x n_elem)
        nids = FE_elem_node[:, e]
        x1, y1 = FE_coords[1, nids[1]], FE_coords[2, nids[1]]
        x2, y2 = FE_coords[1, nids[2]], FE_coords[2, nids[2]]
        x3, y3 = FE_coords[1, nids[3]], FE_coords[2, nids[3]]

        # area = 0.5 * det([[1 x1 y1];[1 x2 y2];[1 x3 y3]])
        detA = (x2 - x1)*(y3 - y1) - (x3 - x1)*(y2 - y1)
        area = 0.5 * detA
        if area <= 0
            # handle possible negative orientation by absolute area (but user may want to warn)
            area = abs(area)
        end

        # linear triangular shape function derivatives (b_i, c_i)
        # Using standard formula: N_i = (a_i + b_i x + c_i y), with
        # b1 = (y2 - y3)/(2A), c1 = (x3 - x2)/(2A), etc.
        denom = 2 * area
        b1 = (y2 - y3) / denom
        b2 = (y3 - y1) / denom
        b3 = (y1 - y2) / denom

        c1 = (x3 - x2) / denom
        c2 = (x1 - x3) / denom
        c3 = (x2 - x1) / denom

        # B matrix 3 x (2*3) following your quad ordering [u1 v1 u2 v2 u3 v3]
        B = zeros(3, 6)
        B[1, 1] = b1; B[1, 3] = b2; B[1, 5] = b3
        B[2, 2] = c1; B[2, 4] = c2; B[2, 6] = c3
        B[3, 1] = c1; B[3, 2] = b1
        B[3, 3] = c2; B[3, 4] = b2
        B[3, 5] = c3; B[3, 6] = b3

        return B, area
    end

    # helper: linear tetra (4-node) -> returns B (6x12) and volume (scalar)
    tet_B_volume = function(e)
        # node ids for tetra
        nids = FE_elem_node[:, e]
        x1, y1, z1 = FE_coords[1, nids[1]], FE_coords[2, nids[1]], FE_coords[3, nids[1]]
        x2, y2, z2 = FE_coords[1, nids[2]], FE_coords[2, nids[2]], FE_coords[3, nids[2]]
        x3, y3, z3 = FE_coords[1, nids[3]], FE_coords[2, nids[3]], FE_coords[3, nids[3]]
        x4, y4, z4 = FE_coords[1, nids[4]], FE_coords[2, nids[4]], FE_coords[3, nids[4]]

        # Build matrix for computing shape function coefficients:
        # |1 x1 y1 z1|
        # |1 x2 y2 z2|
        # |1 x3 y3 z3|
        # |1 x4 y4 z4|
        M = [1.0 x1 y1 z1;
             1.0 x2 y2 z2;
             1.0 x3 y3 z3;
             1.0 x4 y4 z4]

        detM = det(M)
        volume = abs(detM) / 6.0
        if volume <= 0
            # just ensure positive volume
            volume = abs(volume)
        end

        # coefficients [a_i; b_i; c_i; d_i] satisfy M * [a_i b_i c_i d_i]' = e_i
        # where e_i is unit vector selecting node i. Equivalently compute inverse of M:
        Minv = inv(M)

        # For node i, the gradient [b_i, c_i, d_i] are rows 2..4 of Minv corresponding to column i
        # Minv is 4x4; column i corresponds to coefficients for N_i = sum_k Minv[k,i] * phi_k(x)
        # so derivatives are Minv[2:4, i]
        b = zeros(4)
        c = zeros(4)
        d = zeros(4)
        for i_node in 1:4
            # Minv rows: first row = a, next 3 rows = b,c,d for Ni
            b[i_node] = Minv[2, i_node]
            c[i_node] = Minv[3, i_node]
            d[i_node] = Minv[4, i_node]
        end

        # Build B matrix 6 x (3*4) with node order [u1 v1 w1 u2 v2 w2 ...]
        B = zeros(6, 12)
        # row 1: ε_xx = b1 u1 + b2 u2 + ...
        B[1, 1]  = b[1]; B[1, 4]  = b[2]; B[1, 7]  = b[3]; B[1, 10] = b[4]
        # row 2: ε_yy = c1 v1 + c2 v2 + ...
        B[2, 2]  = c[1]; B[2, 5]  = c[2]; B[2, 8]  = c[3]; B[2, 11] = c[4]
        # row 3: ε_zz = d1 w1 + ...
        B[3, 3]  = d[1]; B[3, 6]  = d[2]; B[3, 9]  = d[3]; B[3, 12] = d[4]
        # row 4: ε_xy = c1 u1 + b1 v1 + ...
        B[4, 1]  = c[1]; B[4, 2]  = b[1]
        B[4, 4]  = c[2]; B[4, 5]  = b[2]
        B[4, 7]  = c[3]; B[4, 8]  = b[3]
        B[4, 10] = c[4]; B[4, 11] = b[4]
        # row 5: ε_yz = d1 v1 + c1 w1 + ...
        B[5, 2]  = d[1]; B[5, 3]  = c[1]
        B[5, 5]  = d[2]; B[5, 6]  = c[2]
        B[5, 8]  = d[3]; B[5, 9]  = c[3]
        B[5, 11] = d[4]; B[5, 12] = c[4]
        # row 6: ε_zx = b1 w1 + d1 u1 + ...
        B[6, 1]  = d[1]; B[6, 3]  = b[1]
        B[6, 4]  = d[2]; B[6, 6]  = b[2]
        B[6, 7]  = d[3]; B[6, 9]  = b[3]
        B[6, 10] = d[4]; B[6, 12] = b[4]

        return B, volume
    end

    # determine nodes per element from FE_elem_node shape:
    nodes_per_elem = size(FE_elem_node, 1)

    for e in 1:FE_n_elem
        if FE_dim == 2
            if nodes_per_elem == 3
                # 3-node triangle (constant B, single integration)
                Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
                FE_Ce[:, :, e] = Ce
                B, area = tri_B_area(e)
                FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ area * (B' * Ce * B)
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

        else
            # FE_dim == 3
            if nodes_per_elem == 4
                # 4-node tetra (constant B)
                Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
                FE_Ce[:, :, e] = Ce
                B1, volume1 = tet_B_volume(e)
                FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ volume * (B' * Ce * B)
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

# function Ke_Ce_Update!(FE_Ce, FE_Ke, FE_B0e, 
#     FE_n_elem, FE_dim, FE_material_E, FE_material_nu, FE_coords, FE_elem_node)

#     gauss_pt = [-1 1] / sqrt(3)
#     W = [1 1 1]
#     num_gauss_pt = length(gauss_pt)

#       for e in 1:FE_n_elem
#         if FE_dim == 2
#             #!!!!!!!!!!!!!!!!!!!!!!!!!
#             Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
#             FE_Ce[:, :, e] = Ce
#             #--------------------------------------------------------
#             # Voigt matrix for von Mises stress computation
#             # loop over Gauss Points
#             for i in 1:num_gauss_pt
#                 xi = gauss_pt[i]
#                 for j in 1:num_gauss_pt
#                     eta = gauss_pt[j]
#                     # Compute Jacobian
#                     J = Jacobian(xi, eta, e, FE_coords, FE_elem_node)
#                     det_J = det(J)
#                     inv_J = J \ I(size(J, 1))
#                     # Compute shape function derivatives (strain displacement matrix)
#                     GN = inv_J * G0_N(xi, eta, e)
#                     B = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0 GN[1, 4] 0;
#                         0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3] 0 GN[2, 4];
#                         GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3] GN[2, 4] GN[1, 4]]
#                     FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W[i] * W[j] * det_J * B' * Ce * B
#                 end
#             end
#             J0 = Jacobian(0, 0, e, FE_coords, FE_elem_node)
#             inv_J0 = J0 \ I(size(J0, 1))

#             GN = inv_J0 * G0_N(0, 0, e) # Shape function gradient at element centroid
#             B0 = [GN[1, 1] 0 GN[1, 2] 0 GN[1, 3] 0 GN[1, 4] 0;
#                 0 GN[2, 1] 0 GN[2, 2] 0 GN[2, 3] 0 GN[2, 4];
#                 GN[2, 1] GN[1, 1] GN[2, 2] GN[1, 2] GN[2, 3] GN[1, 3] GN[2, 4] GN[1, 4]]
#             FE_B0e[:, :, e] = B0

#         else
#             Ce = Call_Ce(FE_dim, FE_material_E, FE_material_nu)
#             FE_Ce[:, :, e] = Ce
#             #         loop over Gauss Points
#             for i in 1:num_gauss_pt
#                 xi = gauss_pt[i]
#                 for j in 1:num_gauss_pt
#                     eta = gauss_pt[j]
#                     for k in 1:num_gauss_pt
#                         zeta = gauss_pt[k]
#                         # Compute Jacobian
#                         J = Jacobian8(xi, eta, zeta, e, FE_coords, FE_elem_node)
#                         det_J = det(J)
#                         inv_J = J \ I(size(J, 1))
#                         # Compute shape function derivatives (strain displacement matrix)
#                         GN = inv_J * G0_N8(xi, eta, zeta, e)
#                         B = [GN[1, 1] 0 0 GN[1, 2] 0 0 GN[1, 3] 0 0 GN[1, 4] 0 0 GN[1, 5] 0 0 GN[1, 6] 0 0 GN[1, 7] 0 0 GN[1, 8] 0 0;
#                             0 GN[2, 1] 0 0 GN[2, 2] 0 0 GN[2, 3] 0 0 GN[2, 4] 0 0 GN[2, 5] 0 0 GN[2, 6] 0 0 GN[2, 7] 0 0 GN[2, 8] 0;
#                             0 0 GN[3, 1] 0 0 GN[3, 2] 0 0 GN[3, 3] 0 0 GN[3, 4] 0 0 GN[3, 5] 0 0 GN[3, 6] 0 0 GN[3, 7] 0 0 GN[3, 8];
#                             GN[2, 1] GN[1, 1] 0 GN[2, 2] GN[1, 2] 0 GN[2, 3] GN[1, 3] 0 GN[2, 4] GN[1, 4] 0 GN[2, 5] GN[1, 5] 0 GN[2, 6] GN[1, 6] 0 GN[2, 7] GN[1, 7] 0 GN[2, 8] GN[1, 8] 0;
#                             0 GN[3, 1] GN[2, 1] 0 GN[3, 2] GN[2, 2] 0 GN[3, 3] GN[2, 3] 0 GN[3, 4] GN[2, 4] 0 GN[3, 5] GN[2, 5] 0 GN[3, 6] GN[2, 6] 0 GN[3, 7] GN[2, 7] 0 GN[3, 8] GN[2, 8];
#                             GN[3, 1] 0 GN[1, 1] GN[3, 2] 0 GN[1, 2] GN[3, 3] 0 GN[1, 3] GN[3, 4] 0 GN[1, 4] GN[3, 5] 0 GN[1, 5] GN[3, 6] 0 GN[1, 6] GN[3, 7] 0 GN[1, 7] GN[3, 8] 0 GN[1, 8]]
#                         FE_Ke[:, :, e] = FE_Ke[:, :, e] .+ W[i] * W[j] * W[k] * det_J * B' * Ce * B
#                     end
#                 end
#             end
#             J0 = Jacobian8(0, 0, 0, e, FE_coords, FE_elem_node)
#             inv_J0 = J0 \ I(size(J0, 1))
#             GN = inv_J0 * G0_N8(0, 0, 0, e)
#             B0 = [GN[1, 1] 0 0 GN[1, 2] 0 0 GN[1, 3] 0 0 GN[1, 4] 0 0 GN[1, 5] 0 0 GN[1, 6] 0 0 GN[1, 7] 0 0 GN[1, 8] 0 0;
#                 0 GN[2, 1] 0 0 GN[2, 2] 0 0 GN[2, 3] 0 0 GN[2, 4] 0 0 GN[2, 5] 0 0 GN[2, 6] 0 0 GN[2, 7] 0 0 GN[2, 8] 0;
#                 0 0 GN[3, 1] 0 0 GN[3, 2] 0 0 GN[3, 3] 0 0 GN[3, 4] 0 0 GN[3, 5] 0 0 GN[3, 6] 0 0 GN[3, 7] 0 0 GN[3, 8];
#                 GN[2, 1] GN[1, 1] 0 GN[2, 2] GN[1, 2] 0 GN[2, 3] GN[1, 3] 0 GN[2, 4] GN[1, 4] 0 GN[2, 5] GN[1, 5] 0 GN[2, 6] GN[1, 6] 0 GN[2, 7] GN[1, 7] 0 GN[2, 8] GN[1, 8] 0;
#                 0 GN[3, 1] GN[2, 1] 0 GN[3, 2] GN[2, 2] 0 GN[3, 3] GN[2, 3] 0 GN[3, 4] GN[2, 4] 0 GN[3, 5] GN[2, 5] 0 GN[3, 6] GN[2, 6] 0 GN[3, 7] GN[2, 7] 0 GN[3, 8] GN[2, 8];
#                 GN[3, 1] 0 GN[1, 1] GN[3, 2] 0 GN[1, 2] GN[3, 3] 0 GN[1, 3] GN[3, 4] 0 GN[1, 4] GN[3, 5] 0 GN[1, 5] GN[3, 6] 0 GN[1, 6] GN[3, 7] 0 GN[1, 7] GN[3, 8] 0 GN[1, 8]]
#             FE_B0e[:, :, e] = B0
#         end

#     end

#     nothing
# end