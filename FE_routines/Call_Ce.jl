function Call_Ce(dim, E, nu)
    #---------Plane Strain--------------------------------

    if dim == 2
        a = E / (1 - nu^2)
        b = nu
        c = (1 - nu) / 2
        Ce_2D = a * [1 b 0;
            b 1 0;
            0 0 c]
        Ce = 0.5 * (Ce_2D + transpose(Ce_2D))
    else
        #---------3D----------
        a = E / ((1 + nu) * (1 - 2 * nu))
        b = nu
        c = 1 - nu
        d = (1 - 2 * nu) / 2
        Ce_3D = a * [c b b 0 0 0;
            b c b 0 0 0;
            b b c 0 0 0;
            0 0 0 d 0 0;
            0 0 0 0 d 0;
            0 0 0 0 0 d]
        Ce = 0.5 * (Ce_3D + transpose(Ce_3D))
    end
    return Ce
end
