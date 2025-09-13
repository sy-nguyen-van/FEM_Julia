include("fd_check_cost.jl")
include("fd_check_constraint.jl")
function run_finite_difference_check(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct, check_cost_sens, check_cons_sens, path_output)
    # This function performs a finite difference check of the analytical
    # sensitivities of the cost and/or constraint functions by invoking the
    # corresponding routines.
    if check_cost_sens == true && check_cons_sens == true
        grad_cost_0, grad_cost_i = fd_check_cost(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct)
        grad_const_0, grad_const_i = fd_check_constraint(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct)
    else
        if check_cost_sens == true
            grad_cost_0, grad_cost_i = fd_check_cost(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct)
        elseif check_cons_sens == true
            grad_const_0, grad_const_i = fd_check_constraint(OPT::OPT_struct, FE::FE_struct,SGs::SGs_struct)
        end
    end
    # Vector of index of dv
    if OPT.run_multi_scales == true
        x = LinRange(1, FE.n_elem * 2, FE.n_elem * 2)
    else
        x = LinRange(1, FE.n_elem, FE.n_elem)
    end
    # Name of plots
    name_obj = "FD of cost function: " * OPT.functions.objective

    name_const = "FD of constraint function: " * OPT.functions.constraints

    # --
    if check_cost_sens == true && check_cons_sens == true
        fig_FD1 = Figure()
        ax_FD1 = Axis(fig_FD1[1, 1], xlabel="Design variable: v", ylabel="dz/dv", title=name_obj)
        Makie.lines!(ax_FD1, x, vec(grad_cost_0), color=:red, label="Analytical")
        Makie.scatter!(ax_FD1, x, vec(grad_cost_i), color=:blue, label="FD")
        axislegend(position=:rb)
        # Saving plots
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS * "_FD_cost_" * OPT.functions.objective * ".pdf", fig_FD1)
        # ------
        fig_FD2 = Figure()
        ax_FD2 = Axis(fig_FD2[1, 1], xlabel="Design variable: v", ylabel="dz/dv", title=name_const)
        Makie.lines!(ax_FD2, x, vec(grad_const_0), color=:red, label="Analytical")
        Makie.scatter!(ax_FD2, x, vec(grad_const_i), color=:blue, label="FD")
        axislegend(position=:rb)
        # ------
        # Saving plots
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS * "_FD_const_" * OPT.functions.constraints * ".pdf", fig_FD2)
        # -----
        figs = [fig_FD1, fig_FD2]
    elseif check_cost_sens == true
        fig_FD1 = Figure()
        ax_FD1 = Axis(fig_FD1[1, 1], xlabel="Design variable: v", ylabel="dz/dv", title=name_obj)
        Makie.lines!(ax_FD1, x, vec(grad_cost_0), color=:red, label="Analytical")
        Makie.scatter!(ax_FD1, x, vec(grad_cost_i), color=:blue, label="FD")
        axislegend(position=:rb)
        # ------
        figs = fig_FD1
        # ------
        # Saving plots
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS * "_FD_cost_" * OPT.functions.objective * ".pdf", fig_FD1)
    elseif check_cons_sens == true
        # -------
        fig_FD2 = Figure()
        ax_FD2 = Axis(fig_FD2[1, 1], xlabel="Design variable: v", ylabel="dz/dv", title=name_const, aspect=DataAspect())
        Makie.lines!(ax_FD2, x, vec(grad_const_0), color=:red, label="Analytical")
        Makie.scatter!(ax_FD2, x, vec(grad_const_i), color=:blue, label="FD")
        axislegend(position=:rb)
        figs = fig_FD2
        # ------
        # Saving plots
        Makie.save(path_output * OPT.examples *"_"*OPT.TPMS * "_FD_const_" * OPT.functions.constraints * ".pdf", fig_FD2)
        # ----
    end


    return figs
end