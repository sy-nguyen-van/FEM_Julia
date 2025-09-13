function initial_design(OPT::OPT_struct, FE::FE_struct)
    range_limits_1 = (OPT.LB_macro, OPT.UB_macro)
    range_limits_2 = (0, OPT.UB_micro)
    range_limits_3 = (0, OPT.UB_micro)

    x_centroid = FE.centroids[1, :]
    y_centroid = FE.centroids[2, :]
    xs = FE.coords[1, :]
    ys = FE.coords[2, :]
    Cube = Rect(Vec(0, 0, 0), Vec(FE.max_elem_side * 10, FE.max_elem_side * 10, FE.max_elem_side * 10))

    shape_polygon = [Point2f[(xs[FE.elem_node[:, ele][1]], ys[FE.elem_node[:, ele][1]]), (xs[FE.elem_node[:, ele][2]], ys[FE.elem_node[:, ele][2]]),
        (xs[FE.elem_node[:, ele][3]], ys[FE.elem_node[:, ele][3]]), (xs[FE.elem_node[:, ele][4]], ys[FE.elem_node[:, ele][4]])
    ] for ele in 1:size(FE.elem_node, 2)]

    if OPT.run_multi_scales == 0
        range_limits = (0, OPT.UB_micro)
        if FE.dim == 2
            fig1 = Figure()
            ax1 = Axis(fig1[1, 1], title=OPT.TPMS * "-Micro Design", xlabel="X", ylabel="Y", aspect=DataAspect())
            xlims!(ax1, 0, max.(FE.coord_max)[1])
            ylims!(ax1, 0, max.(FE.coord_max)[2])
            colsize!(fig1.layout, 1, Aspect(1, max.(FE.coord_max)[1] / max.(FE.coord_max)[2]))
            Makie.resize_to_layout!(fig1)
            Makie.poly!(ax1, shape_polygon, color=OPT.dv_micro, colormap=:jet)
            Makie.Colorbar(fig1[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits)
        else
            z_centroid = FE.centroids[3, :]
            # plot mesh with macro density
            fig1 = Figure()
            ax1 = Axis3(fig1[1, 1], title=OPT.TPMS * "-Macro Density", xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
            xlims!(ax1, 0, max.(FE.coord_max)[1])
            ylims!(ax1, 0, max.(FE.coord_max)[2])
            zlims!(ax1, 0, max.(FE.coord_max)[3])
            Makie.meshscatter!(ax1, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.dv_micro, colorrange=range_limits, colormap=:jet)
            Makie.Colorbar(fig1[1, 2], colormap=:jet, label="Density", colorrange=range_limits)
        end
        ax2, fig2, ax3, fig3 = [], [], [], []
    else
        # # Get coordinates and vertices
        if FE.dim == 2
            xs = FE.coords[1, :]
            ys = FE.coords[2, :]
            shape_polygon = [Point2f[(xs[FE.elem_node[:, ele][1]], ys[FE.elem_node[:, ele][1]]), (xs[FE.elem_node[:, ele][2]], ys[FE.elem_node[:, ele][2]]),
                (xs[FE.elem_node[:, ele][3]], ys[FE.elem_node[:, ele][3]]), (xs[FE.elem_node[:, ele][4]], ys[FE.elem_node[:, ele][4]])
            ] for ele in 1:size(FE.elem_node, 2)]
            # # Get coordinates and vertices
            # plot mesh with macro density
            fig1 = Figure()
            ax1 = Axis(fig1[1, 1], title=OPT.TPMS * "-Macro Density", xlabel="X", ylabel="Y", aspect=DataAspect())
            xlims!(ax1, 0, max.(FE.coord_max)[1])
            ylims!(ax1, 0, max.(FE.coord_max)[2])
            colsize!(fig1.layout, 1, Aspect(1, max.(FE.coord_max)[1] / max.(FE.coord_max)[2]))
            resize_to_layout!(fig1)
            # Makie.poly!(ax1, shape_polygon, color=OPT.pen_rho_e, colormap=:jet)
            Makie.heatmap!(ax1, x_centroid, y_centroid, OPT.pen_rho_e, colormap=:jet)
            Makie.Colorbar(fig1[1, 2], colormap=:jet, label="Density", colorrange=range_limits_1)
            # plot mesh with macro density
            fig2 = Figure()
            ax2 = Axis(fig2[1, 1], title=OPT.TPMS * "-Micro Design", xlabel="X", ylabel="Y", aspect=DataAspect())
            xlims!(ax2, 0, max.(FE.coord_max)[1])
            ylims!(ax2, 0, max.(FE.coord_max)[2])
            colsize!(fig2.layout, 1, Aspect(1, max.(FE.coord_max)[1] / max.(FE.coord_max)[2]))
            Makie.resize_to_layout!(fig2)
            # Makie.poly!(ax2, shape_polygon, color=OPT.dv_micro, colormap=:jet)
            Makie.heatmap!(ax2, x_centroid, y_centroid, OPT.dv_micro, colormap=:jet)
            Makie.Colorbar(fig2[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits_2)
            # plot mesh with macro density
            fig3 = Figure()
            ax3 = Axis(fig3[1, 1], title=OPT.TPMS * "-Multi Scale Design", xlabel="X", ylabel="Y", aspect=DataAspect())
            xlims!(ax3, 0, max.(FE.coord_max)[1])
            ylims!(ax3, 0, max.(FE.coord_max)[2])
            colsize!(fig3.layout, 1, Aspect(1, max.(FE.coord_max)[1] / max.(FE.coord_max)[2]))
            Makie.resize_to_layout!(fig3)
            # Makie.poly!(ax3, shape_polygon, color=OPT.dv_micro .* OPT.pen_rho_e, colormap=:jet)
            Makie.heatmap!(ax3, x_centroid, y_centroid, OPT.dv_micro .* OPT.pen_rho_e, colormap=:jet)
            Makie.Colorbar(fig3[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits_3)
        else

            z_centroid = FE.centroids[3, :]
            # plot mesh with macro density
            fig1 = Figure()
            ax1 = Axis3(fig1[1, 1], title=OPT.TPMS * "-Macro Density", xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
            xlims!(ax1, 0, max.(FE.coord_max)[1])
            ylims!(ax1, 0, max.(FE.coord_max)[2])
            zlims!(ax1, 0, max.(FE.coord_max)[3])
            Makie.meshscatter!(ax1, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.pen_rho_e, colorrange=range_limits_1, colormap=:jet)
            Makie.Colorbar(fig1[1, 2], colormap=:jet, label="Density", colorrange=range_limits_1)

            # plot mesh with macro density
            fig2 = Figure()
            ax2 = Axis3(fig2[1, 1], title=OPT.TPMS * "-Micro Design", xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
            xlims!(ax2, 0, max.(FE.coord_max)[1])
            ylims!(ax2, 0, max.(FE.coord_max)[2])
            zlims!(ax2, 0, max.(FE.coord_max)[3])
            Makie.meshscatter!(ax2, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.dv_micro, colorrange=range_limits_2, colormap=:jet)
            Makie.Colorbar(fig2[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits_2)

            # plot mesh with macro density
            fig3 = Figure()
            ax3 = Axis3(fig3[1, 1], title=OPT.TPMS * "-Multi Scale Design", xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
            xlims!(ax3, 0, max.(FE.coord_max)[1])
            ylims!(ax3, 0, max.(FE.coord_max)[2])
            zlims!(ax3, 0, max.(FE.coord_max)[3])
            Makie.meshscatter!(ax3, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.dv_micro .* OPT.pen_rho_e, colorrange=range_limits_3, colormap=:jet)
            Makie.Colorbar(fig3[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits_3)

        end

    end
    return Cube, shape_polygon, ax1, fig1, ax2, fig2, ax3, fig3
end