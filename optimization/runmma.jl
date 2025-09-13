# Define struct for History 
mutable struct History_Opt
    iter::Vector{Int64}
    f0val::Vector{Float64}
    fval::Vector{Float64}
    grf::Vector{Float64}
end
# Define struct for Adaprive Constraint Scaling 
mutable struct ACS_Opt
    use::Bool
    alpha_osc::Float64
    alpha_no_osc::Float64
    c::Vector{Float64}
end
# Define struct for Moving of Asymptotes's Parameter
mutable struct MMA_Opt
    version::Int64
    c::Vector{Float64}
    d::Vector{Float64}
    a0::Float64
    a::Vector{Float64}
    move_limit::Float64
end
#--------------------------------------------

function runmma(OPT::OPT_struct, FE::FE_struct, SGs::SGs_struct, x0, path_output)
    # Initialize history object
    history = History_Opt([], [], [], [])
    # -----------Adaptive constraint scaling
    ACS = ACS_Opt(true, 0.8, 1, [])

    if (OPT.functions.objective == "maximum_damage_multi_scales" || OPT.functions.objective == "maximum_damage_SGs"
        || OPT.functions.objective == "maximum_stress_multi_scales" || OPT.functions.objective == "maximum_stress_SGs"
        || OPT.functions.objective == "compliance_multi_scales" || OPT.functions.objective == "compliance"
        )
        ACS.use = false
    end

    ncons = OPT.functions.ncons
    MMA = MMA_Opt(
        1999,  # version
        1000 * ones(ncons),  # c
        ones(ncons),  #d
        1.0,  # a0
        zeros(ncons), # a
        0.02 # move_limit
    )


    if OPT.run_multi_scales == true
        lb = vec([OPT.LB_macro * ones(FE.n_elem); OPT.LB_micro * ones(FE.n_elem)])
        ub = vec([OPT.UB_macro * ones(FE.n_elem); OPT.UB_micro * ones(FE.n_elem)])
    else
        lb = OPT.LB_macro * ones(FE.n_elem)
        ub = OPT.UB_macro * ones(FE.n_elem)
    end
    #
    ndv = copy(OPT.n_dv) # Number of design variables
    # Initialize vectors that store current and previous two design iterates
    x = copy(x0)
    xold1 = copy(x0)
    xold2 = copy(x0)
    # Initialize move limits
    ml_step = MMA.move_limit * abs.(ub .- lb)  # Compute move limits once
    # Initialize lower and upper asymptotes
    low = copy(lb)
    upp = copy(ub)
    # These are the MMA constants (Svanberg, 1998 DACAMM Course)
    c = copy(MMA.c)
    d = copy(MMA.d)
    a0 = copy(MMA.a0)
    a = copy(MMA.a)
    # Evaluate the initial design and print values to screen
    iter = 0
    f0val, df0dx, fval, dfdx, OPT, FE = obj_nonlcon(OPT::OPT_struct, FE::FE_struct, SGs::SGs_struct, x)


    #### Initialize stopping values
    obj_change = 10 * OPT.options.obj_tol
    # # Produce output to screen
    # overwritten.
    filename = path_output * OPT.examples * "_" * OPT.TPMS * "_" * OPT.functions.objective * "_" * OPT.functions.constraints * "_History.txt"
    # ===================
    t1 = time(); # Start 
    # Open the file for writing
    fid = open(filename, "w")
    # Write header
    println(fid, "Start time: ", Dates.format(now(), "yyyy-mm-dd HH:MM"))
    println(fid, "Problem: ", OPT.examples)
    println(fid, "Cell size = ", FE.max_elem_side, " (mm)")
    println(fid, "Number of elements = ", FE.n_elem)

    println(fid, "Objective: ", OPT.functions.objective)
    println(fid, "Constraint: ", OPT.functions.constraints)
    println(fid, "E = ", FE.material.E," (MPa); nu = ", FE.material.nu, "; Relax stress power = ",OPT.relax_power, "; P-norm = ", OPT.aggregation_power, "; Max Iter = ", OPT.options.max_iter)
    println(fid, "F = ", OPT.load_amplitude, " (N); Stress limit = ", OPT.functions.stress_limit, " (MPa)")
    # =============================================
    println(fid, "Start topology optimization:")

    println(fid, "It. ", iter, ", Obj = ", @sprintf("%.5e", f0val), ", ConsViol = ", @sprintf("%.5e", fval), ", Obj change = ", @sprintf("%.5e", obj_change))

    @printf("It. %d, Obj= %.5e, ConsViol = %.5e, Obj change = %.5e \n", iter, f0val, fval, obj_change)

    dfdx = transpose(dfdx)
    df0dx_zero = 0 * df0dx # df0dx_zero  
    dfdx_zero = 0 * dfdx # dfdx_zero
    push!(history.iter, iter)
    push!(history.f0val, f0val)
    push!(history.fval, fval)
    ## ---------Show the 1st plot-------------

    Cube, shape_polygon, ax1, fig1, ax2, fig2, ax3, fig3 = initial_design(OPT::OPT_struct, FE::FE_struct)
    # --------------------
    # ******* MAIN MMA LOOP STARTS *******
    while iter < OPT.options.max_iter
        OPT.iter = iter
        iter = iter + 1
        if OPT.run_stress
            if all(OPT.true_stress_fatigue_max .<= 1.2 * OPT.functions.stress_limit)
                step_fac = 2.0
            else
                step_fac = 1.0
            end
        else
            step_fac = 1.0
        end
        mlb = max.(lb, x .- step_fac * ml_step)
        mub = min.(ub, x .+ step_fac * ml_step)

        # Adaptive Scaling Constraint
        cc, ACS = ACS_Call(ACS, iter, OPT)
        fval = cc * (fval + 1) - 1
        # Function scaling
        f0val = OPT.functions.objective_scale * f0val
        df0dx = OPT.functions.objective_scale * df0dx
        fval = transpose(OPT.functions.constraints_scale) .* fval
        dfdx = transpose(OPT.functions.constraints_scale) .* dfdx

        xmma, ymma, zmma, lam, xsi, eta, mu, zet, s, low, upp =
            mma1999(ncons, ndv, iter, x, mlb, mub, xold1, xold2,
                f0val, df0dx, df0dx_zero, fval, dfdx, dfdx_zero, low, upp, a0, a, c, d)


        # #### Updated design vectors of previous and current iterations
        xold2 .= copy(xold1)
        xold1 .= copy(x)
        x .= copy(xmma)

        # # Update function values and gradients
        # # Note that OPT.dv gets updated inside these functions
        f0val, df0dx, fval, dfdx, OPT, FE = obj_nonlcon(OPT::OPT_struct, FE::FE_struct, SGs::SGs_struct, copy(xmma))

        dfdx = transpose(dfdx)

        # Compute gray region fraction, which serves as an indication of
        # convergence to 0-1 design.
        grf = (4 / sum(FE.elem_vol)) * dot(OPT.dv[OPT.index_dv_macro] .* (1 .- OPT.dv[OPT.index_dv_macro]), FE.elem_vol)
        
        out_const = OPT.true_h_max - 1

        if OPT.functions.constraints == "volume_fraction_multi_scales" 
            out_const = fval
        end
        push!(history.iter, iter)
        push!(history.f0val, f0val)
        # push!(history.fval, fval) 
        push!(history.fval, out_const)
        push!(history.grf, grf)
        ## Compute norm of KKT residual vector
        residu, kktnorm, residumax = kktcheck(ncons, ndv, xmma, ymma, zmma,
            lam, xsi, eta, mu, zet, s, lb, ub, df0dx, fval, dfdx, a0, a, c, d)


        if iter > 1
            obj_change = (history.fval[iter] - history.fval[iter-1]) / history.fval[iter-1]
            if abs(obj_change) < OPT.options.obj_tol
                @printf("Objective function convergence tolerance satisfied. \n")
                println(fid, "Objective function convergence tolerance satisfied")
            end
        end
        # # Produce output to screen
        

        @printf("It. %d, Obj= %.5e, ConsViol = %.5e, KKT-norm = %.5e, Obj change = %.5e \n",
            iter, f0val, out_const, kktnorm, obj_change)

        println(fid, "It. ", iter, ", Obj = ", @sprintf("%.5e", f0val), ", ConsViol = ", @sprintf("%.5e", out_const), ", KKT-norm = ", @sprintf("%.5e", kktnorm), ", Obj change = ", @sprintf("%.5e", obj_change))

        # ===Stopping criteria====
        if abs(obj_change) < OPT.options.obj_tol && grf < OPT.options.max_GRF
            @printf("Satisfied stopping criteria. \n")
            close(fid)
            break
        end
        # =====
        # show_design_iter(OPT::OPT_struct, FE::FE_struct,Cube, shape_polygon, ax1, fig1, ax2, fig2, ax3, fig3)
        # Open a file in write mode and save the number
        if OPT.run_SGs == 1
            open(OPT.examples * "_Iteration_SGs.txt", "w") do file
                write(file, "Iter: " * string(iter) * ", Obj = " * string(@sprintf("%.5e", f0val)) * ", ConsViol = " * string(@sprintf("%.5e", out_const)))
            end
        else
            open(OPT.examples*  "_Iteration.txt", "w") do file
                write(file, "Iter: " * string(iter) * ", Obj = " * string(@sprintf("%.5e", f0val)) * ", ConsViol = " * string(@sprintf("%.5e", out_const)))
            end
        end
    end
    
    println(fid, "The final volume fraction is: ", round(OPT.volume_fraction, digits=3))
    println(fid, "The final maximum von Mises: ", round(OPT.true_stress_fatigue_max, digits=3), " (MPa)")
    println(fid, "End time: ", Dates.format(now(), "yyyy-mm-dd HH:MM"))

    println(fid, "Total executing time: ",  round(time() - t1, digits=3), " (s)")
    println(fid, "Executing time/iter: ",  round((time() - t1)/iter, digits=3), " (s)")
    close(fid)
    # ======================
    return OPT, FE, history
end