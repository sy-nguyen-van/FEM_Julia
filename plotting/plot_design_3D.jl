

function plot_design_3D(OPT::OPT_struct, FE::FE_struct, history,path_output)

    range_limits_1 = (OPT.LB_macro, OPT.UB_macro)
    range_limits_2 = (0, OPT.UB_micro)
    range_limits_3 = (0, OPT.UB_micro)

    Cube = Rect(Vec(0, 0, 0), Vec(FE.max_elem_side*10, FE.max_elem_side*10, FE.max_elem_side*10))
    x_centroid = FE.centroids[1, :]
    y_centroid = FE.centroids[2, :]
    z_centroid = FE.centroids[3, :]
    # ---
    # Name of plots
    name_obj = "hist_cost_" * OPT.functions.objective * ".pdf"
    name_const = "hist_const_" * OPT.functions.constraints * ".pdf"
    # plot mesh with macro density
    fontsize = 16
    if OPT.run_multi_scales == true
        # ==========================
        Multi_Design = hcat(x_centroid, y_centroid, z_centroid, OPT.dv_micro .* OPT.pen_rho_e)
        # ==========================
        # plot mesh with macro density
        fig1 = Figure(fontsize=16)
        ax1 = Axis3(fig1[1, 1], title=OPT.TPMS * "-Macro Density", xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
        xlims!(ax1, 0, max.(FE.coord_max)[1])
        ylims!(ax1, 0, max.(FE.coord_max)[2])
        zlims!(ax1, 0, max.(FE.coord_max)[3])

        Makie.meshscatter!(ax1, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.pen_rho_e, colorrange=range_limits_1, colormap=:jet)
        Makie.Colorbar(fig1[1, 2], colormap=:jet, label="Density", colorrange=range_limits_1)

        # plot mesh with macro density
        fig2 = Figure(fontsize=16)
        ax2 = Axis3(fig2[1, 1], title=OPT.TPMS * "-Micro Design", xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
        xlims!(ax2, 0, max.(FE.coord_max)[1])
        ylims!(ax2, 0, max.(FE.coord_max)[2])
        zlims!(ax2, 0, max.(FE.coord_max)[3])
        Makie.meshscatter!(ax2, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.dv_micro, colorrange=range_limits_2, colormap=:jet)
        Makie.Colorbar(fig2[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits_2)

        # plot mesh with macro density
        fig3 = Figure(fontsize=16)
        ax3 = Axis3(fig3[1, 1], title=OPT.TPMS * "-Multi Scale Design", xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)
        xlims!(ax3, 0, max.(FE.coord_max)[1])
        ylims!(ax3, 0, max.(FE.coord_max)[2])
        zlims!(ax3, 0, max.(FE.coord_max)[3])
        Makie.meshscatter!(ax3, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.dv_micro .* OPT.pen_rho_e, colorrange=range_limits_3, colormap=:jet)
        Makie.Colorbar(fig3[1, 2], colormap=:jet, label="Thickness", colorrange=range_limits_3)


        # plot history of cost function
        fig4 = Figure(fontsize=16)
        ax4 = Axis(fig4[1, 1], title="History of Cost Function", xlabelsize=fontsize, ylabelsize=fontsize, xlabel="Iterations", ylabel="Cost")
        # Plot the values with lines
        # Create a new axis for the second plot
        Makie.lines!(ax4, history.iter, history.f0val, linewidth=2, linestyle=:solid, color=:red, label=OPT.TPMS * "-Cost")
        # Display the plot
        # Show the legend
        axislegend(position=:rc; labelsize=16)
        # plot history of constraint function
        fig5 = Figure(fontsize=16)
        ax5 = Axis(fig5[1, 1], title="History of Constraint Function", xlabelsize=fontsize, ylabelsize=fontsize, xlabel="Iterations", ylabel="Constraint")
        # Plot the values with lines
        Makie.lines!(ax5, history.iter, history.fval, linewidth=2, linestyle=:solid, color=:blue, label=OPT.TPMS * "-Constraint")
        # Display the plot
        axislegend(position=:rc; labelsize=16)
        ## =============Save stress and life=================================
        if OPT.run_stress == 1
            # plot stress 
            for iload in 1:FE.nloads
                range_limits = (minimum(FE.svm), OPT.functions.stress_limit[iload])
                fig6 = Figure(fontsize=16)
                ax6 = Axis3(fig6[1, 1], title=OPT.TPMS * "-VonMises Stress", xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="X", ylabel="Y", zlabel="Z", aspect=:data)

                Makie.meshscatter!(ax6, x_centroid, y_centroid, z_centroid, marker=Cube, color=vec(FE.svm[:, iload]), colorrange=range_limits, colormap=:jet)

                Makie.Colorbar(fig6[1, 2], colormap=:jet, label="Stress", colorrange=range_limits)
                xlims!(ax6, 0, max.(FE.coord_max)[1])
                ylims!(ax6, 0, max.(FE.coord_max)[2])

                if OPT.run_SGs == 0
                    Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_VonMises_iload_" * string(iload) * ".png", fig6)
                else
                    Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_SGs_VonMises_" * string(iload) * ".png", fig6)
                end
            end
        end
        figs = [fig1, fig2, fig3, fig4, fig5]
        ## ===========Save figs============
        if OPT.run_stress == 1 && OPT.run_SGs == 0
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_macro.png", fig1)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_micro.png", fig2)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_multi.png", fig3)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_" * name_obj, fig4)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_stress_" * name_const, fig5)
            # write out a DataFrame to csv file
            file_CSV = path_output * OPT.examples * "_" * OPT.TPMS * "_stress_multi.csv"
            df = DataFrame(Multi_Design, :auto)
            CSV.write(file_CSV, df)
        elseif OPT.run_stress == 1 && OPT.run_SGs == 1
            Makie.save(path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints* "_stress_SGs_macro.png", fig1)
            Makie.save(path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints* "_stress_SGs_micro.png", fig2)
            Makie.save(path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints* "_stress_SGs_multi.png", fig3)
            Makie.save(path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints* "_stress_SGs_" * name_obj, fig4)
            Makie.save(path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints* "_stress_SGs_" * name_const, fig5)
            # write out a DataFrame to csv file
            file_CSV = path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints * "_stress_SGs_multi.csv"
            df = DataFrame(Multi_Design, :auto)
            CSV.write(file_CSV, df)
        elseif OPT.run_stress == 0
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_macro.png", fig1)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_micro.png", fig2)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_multi.png", fig3)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_" * name_obj, fig4)
            Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_" * name_const, fig5)
            # write out a DataFrame to csv file
            file_CSV = path_output * OPT.examples * "_" * OPT.TPMS * "_multi.csv"
            df = DataFrame(Multi_Design, :auto)
            CSV.write(file_CSV, df)
        end

    else  # ===============Single scale =========================
        fig1 = Figure(fontsize=16)
        ax1 = Axis(fig1[1, 1], title=OPT.TPMS * "-Single Scale Design", xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="X", ylabel="Y", aspect=DataAspect())

        Makie.meshscatter!(ax1, x_centroid, y_centroid, z_centroid, marker=Cube, color=OPT.dv_micro, colorrange=range_limits_1, colormap=:jet)

        Makie.Colorbar(fig1[1, 2], colormap=:jet, label="Micro")
        xlims!(ax1, 0, max.(FE.coord_max)[1])
        ylims!(ax1, 0, max.(FE.coord_max)[2])
        ##=================================
        # plot history of cost function
        fig2 = Figure(fontsize=16)
        ax2 = Axis(fig2[1, 1], title="History of Cost: " * OPT.functions.objective, xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="Iterations", ylabel="Cost")
        Makie.lines!(ax2, history.iter, history.f0val, linewidth=1.2, color=:red, label="Cost")
        axislegend(position=:rc)

        # plot history of constraint function
        fig3 = Figure(fontsize=16)
        ax3 = Axis(fig3[1, 1], title="History of Constraint: " * OPT.functions.constraints, xlabelsize = fontsize, ylabelsize = fontsize ,xlabel="Iterations", ylabel="Constraint")
        Makie.lines!(ax3, history.iter, history.fval, linewidth=1.2, color=:red, label="Constraint")
        axislegend(position=:rc)
        # ---------
        figs = [fig1, fig2, fig3]
        ##=================================
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_single_scale.png", fig1)
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_single_scale_" * name_obj, fig2)
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS* "_single_scale_" * name_const, fig3)
    end

    return figs
end