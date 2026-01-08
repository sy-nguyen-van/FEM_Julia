function relaxdens(x, p, q, rhomin, type)
    # Compute relaxed density for stress definition
    #
    # x      : design variable density
    # p, q   : relaxation exponents
    # rhomin : minimum density
    # type   : "stdpq" or "modpq"

    if type == "stdpq"
        r = x .^ (p - q)
        drdx = (p - q) .* x .^ (p - q - 1)

    elseif type == "modpq"
        rp = rhomin .+ (1 - rhomin) .* (x .^ p)
        rq = rhomin .+ (1 - rhomin) .* (x .^ q)
        r = rp ./ rq
        drdx = (1 - rhomin) .* (p .* x .^(p - 1) .- q .* (x .^(q - 1)) .* r) ./ rq

    else
        error("Error in relaxdens: unknown relaxation type.")
    end

    return r, drdx
end
