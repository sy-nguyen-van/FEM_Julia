function FE_compute_element_info(FE::FE_struct)
    el_type = FE.elem_type[1]
    dim = el_type in (:CPS3, :Quad4) ? 2 : 3
    FE.dim = dim

    FE.elem_vol = zeros(FE.n_elem)

    FE.centroids = zeros(dim, FE.n_elem)

    for e in 1:FE.n_elem
        # Get element nodes, drop any zero-padding
        nodes = FE.elem_node[:, e]
        nodes = nodes[nodes .!= 0]
        coords = FE.coords[:, nodes]   # dim × nen
        nen = size(coords, 2)
        # Determine element type from FE.elem_type[e]
        el_type = FE.elem_type[e]
        # Centroid = mean of coordinates
        FE.centroids[:, e] .= sum(coords, dims=2)[:] / nen



        if dim == 2
            if el_type == :CPS3
                x1, y1 = coords[:, 1]
                x2, y2 = coords[:, 2]
                x3, y3 = coords[:, 3]
                FE.elem_vol[e] = 0.5 * abs((x2 - x1)*(y3 - y1) - (x3 - x1)*(y2 - y1))
            elseif el_type == :Quad4
                x1, y1 = coords[:, 1]
                x2, y2 = coords[:, 2]
                x3, y3 = coords[:, 3]
                x4, y4 = coords[:, 4]
                A1 = 0.5 * abs((x2 - x1)*(y3 - y1) - (x3 - x1)*(y2 - y1))
                A2 = 0.5 * abs((x4 - x1)*(y3 - y1) - (x3 - x1)*(y4 - y1))
                FE.elem_vol[e] = A1 + A2
            else
                error("Unsupported 2D element type: $el_type")
            end
        elseif dim == 3
            if el_type == :Tet4
                v1 = coords[:, 2] - coords[:, 1]
                v2 = coords[:, 3] - coords[:, 1]
                v3 = coords[:, 4] - coords[:, 1]
                FE.elem_vol[e] = abs(dot(v1, cross(v2, v3))) / 6
            elseif el_type == :Hex8
                n1, n2, n3, n4, n5, n6, n7, n8 = eachcol(coords)
                V = dot((n7-n2)+(n8-n1), cross(n7-n4, n3-n1)) +
                    dot((n8-n1), cross((n7-n4)+(n6-n1), n7-n5)) +
                    dot((n7-n2), cross(n6-n1, (n7-n5)+(n3-n1)))
                FE.elem_vol[e] = abs(V) / 12
            else
                error("Unsupported 3D element type: $el_type")
            end
        else
            error("Unsupported dimension: $dim")
        end
    end

    # Mesh bounding box
    FE.coord_max = [maximum(row) for row in eachrow(FE.coords)]
    FE.coord_min = [minimum(row) for row in eachrow(FE.coords)]

    return FE
end
