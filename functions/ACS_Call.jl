function ACS_Call(ACS, iter, OPT)

    if ACS.use == 1
        if iter <= 3
            cc = 1
        else
            c_old3 = ACS.c[iter-3]
            c_old2 = ACS.c[iter-2]
            c_old1 = ACS.c[iter-1]
            if (c_old3 - c_old2) * (c_old2 - c_old1) < 0
                alpha = copy(ACS.alpha_osc)
            else
                alpha = copy(ACS.alpha_no_osc)
            end
            cc = OPT.true_h_max / OPT.approx_h_max # This works!
            cc = alpha * cc + (1 - alpha) * c_old1
        end
        push!(ACS.c, cc)
    else
        cc = 1
    end

    return cc, ACS
end
