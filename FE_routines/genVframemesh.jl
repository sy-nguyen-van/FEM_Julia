include("generate_mesh.jl")
function genVframemesh(FE::FE_struct)
    # This function generates a mesh for a rectangular frame with an inverted
    # V-shape cutout.
    #


    # First, generate a rectangular mesh with the dimensions and number of
    # elements per side specified in the input file:
    FE = generate_mesh(FE)

    W = FE.mesh_input.box_dimensions[1]
    H = FE.mesh_input.box_dimensions[2]
    VW = FE.mesh_input.cutout_dimensions[1]
    VH = FE.mesh_input.cutout_dimensions[2]
    d = (W - VW) / 2
    he = FE.mesh_input.box_dimensions[1] / FE.mesh_input.elements_per_side[1]

    # Bias the x-coordinates to that when the V-shape cutout is created, the
    # aspect ratio of the elements is close to 1. Use spline fit.
    fac = 1
    pp_left = [0 0 1 0;0 0 0 1;1 1 1 1;3 2 1 0]\[1, 0, 1 ,fac * VH / H]  # solve coefff from A\B; B[1] and B[end] are slopes
    pp_right = [0 0 1 0;0 0 0 1;1 1 1 1;3 2 1 0]\[fac * VH / H, 0, 1 ,1] # solve coefff from A\B; B[1] and B[end] are slopes
    spl = (coeff, x) -> coeff[1]*x.^3 .+ coeff[2]*x.^2 .+ coeff[3]*x.^1 .+ coeff[4] # cubic function
    # pp_left = spline([0 1], [1 0 1 fac * VH / H]) # from Matlab
    # pp_right = spline([0 1], [fac * VH / H 0 1 1]) # from Matlab
    for inode in 1:FE.n_node
        x = FE.coords[1, inode]
        if x .> d .&& x .< W - d
            if x .< W / 2
                FE.coords[1, inode] = d + (W / 2 - d) * spl(pp_left, (x - d) / (W / 2 - d))
            elseif x .> W / 2
                FE.coords[1, inode] = W / 2 + (W / 2 - d) * spl(pp_right, (x - W / 2) / (W / 2 - d))
            end
        end
    end

    # Now, deform the y-coordinates of the mesh to generate the V-shape cutout
    for inode in 1:FE.n_node
        x = FE.coords[1, inode]
        if x .> d .&& x .< W - d
            old_y = FE.coords[2, inode]
            s = (H - old_y) / H
            if x .<= W / 2
                l = H - ((x - d) / ((W / 2) - d)) * VH
            else
                l = H + ((x - W / 2) / ((W / 2) - d) - 1) * VH
            end
            new_y = H - s * l
            FE.coords[2, inode] = new_y
        end
    end

    return FE

end