function show_design_iter(OPT::OPT_struct, FE::FE_struct, Cube, shape_polygon, ax1, fig1, ax2, fig2, ax3, fig3)
    x_centroid = FE.centroids[1, :]
    y_centroid = FE.centroids[2, :]
    if FE.dim == 2
        if OPT.run_multi_scales == 0
            Makie.poly!(ax1, shape_polygon, color=OPT.dv_micro, colormap=:jet)
        else
            # Makie.poly!(ax1, shape_polygon, color=OPT.pen_rho_e, colormap=:jet)
            # Makie.poly!(ax2, shape_polygon, color=OPT.dv_micro, colormap=:jet)
            # Makie.poly!(ax3, shape_polygon, color=OPT.dv_micro .* OPT.pen_rho_e, colormap=:jet)

            Makie.heatmap!(ax1, x_centroid, y_centroid, OPT.pen_rho_e, colormap=:jet)
            Makie.heatmap!(ax2, x_centroid, y_centroid, OPT.dv_micro, colormap=:jet)
            Makie.heatmap!(ax3, x_centroid, y_centroid, OPT.dv_micro .* OPT.pen_rho_e, colormap=:jet)
        end
    else
        z_centroid = FE.centroids[3, :]
        if OPT.run_multi_scales == 0
            Makie.meshscatter!(ax1, x_centroid, y_centroid, z_centroid, marker = Cube, color = OPT.dv_micro, colormap=:jet)
        else
            Makie.meshscatter!(ax1, x_centroid, y_centroid, z_centroid, marker = Cube, color = OPT.pen_rho_e, colormap=:jet)
            Makie.meshscatter!(ax2, x_centroid, y_centroid, z_centroid, marker = Cube, color = OPT.dv_micro, colormap=:jet)
            Makie.meshscatter!(ax3, x_centroid, y_centroid, z_centroid, marker = Cube, color = OPT.dv_micro .* OPT.pen_rho_e, colormap=:jet)
        end
    end
    Makie.save(OPT.examples*"_Macro_Evolution.png", fig1)
    # Makie.save(OPT.examples*"_Multi_Scale_Evolution.png", fig3)
    # display(fig1)
    # ----------------------------
end