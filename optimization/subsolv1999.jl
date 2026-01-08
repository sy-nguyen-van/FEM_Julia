
#    This is the file subsolv.m
#
function subsolv1999(m, n, epsimin, low, upp, alfa, beta, p0, q0, P, Q, a0, a, b, c, d)
    #
    #    Written in May 1999 by
    #    Krister Svanberg <krille@math.kth.se>
    #    Department of Mathematics
    #    SE-10044 Stockholm, Sweden.
    #
    # This function subsolv solves the MMA subproblem:
    #
    # minimize   SUM[ p0j/(uppj-xj) + q0j/(xj-lowj) ] + a0*z +
    #          + SUM[ ci*yi + 0.5*di*(yi)^2 ],
    #
    # subject to SUM[ pij/(uppj-xj) + qij/(xj-lowj) ] - ai*z - yi <= bi,
    #            alfaj <=  xj <=  betaj,  yi >= 0,  z >= 0.
    #
    # Input:  m, n, low, upp, alfa, beta, p0, q0, P, Q, a0, a, b, c, d.
    # Output: xmma,ymma,zmma, slack variables and Lagrange multiplers.
    #
    een = ones(n)
    eem = ones(m)
    epsi = 1
    epsvecn = epsi * een
    epsvecm = epsi * eem
    x = 0.5 * (alfa + beta)
    y = copy(eem)
    z = 1
    lam = copy(eem)
    xsi = een ./ (x - alfa)
    xsi = max.(xsi, een)
    eta = een ./ (beta - x)
    eta = max.(eta, een)
    mu = max.(eem, 0.5 * c)
    zet = 1
    s = copy(eem)
    itera = 0

    while epsi > epsimin
        epsvecn = epsi * een
        epsvecm = epsi * eem
        ux1 = upp .- x
        xl1 = x .- low
        ux2 = ux1 .* ux1
        xl2 = xl1 .* xl1
        uxinv1 = een ./ ux1
        xlinv1 = een ./ xl1

        plam = p0 .+ transpose(P) * lam
        qlam = q0 .+ transpose(Q) * lam
        gvec = P * uxinv1 .+ Q * xlinv1
        dpsidx = plam ./ ux2 - qlam ./ xl2

        rex = dpsidx .- xsi .+ eta
        rey = c .+ d .* y .- mu .- lam
        rez = a0 - zet - transpose(a) * lam
        relam = gvec .- a * z .- y .+ s .- b
        rexsi = xsi .* (x - alfa) .- epsvecn
        reeta = eta .* (beta - x) .- epsvecn
        remu = mu .* y .- epsvecm
        rezet = zet * z .- epsi
        res = lam .* s .- epsvecm

        residu1 = transpose([transpose(rex) transpose(rey) rez])
        residu2 = transpose([transpose(relam) transpose(rexsi) transpose(reeta) transpose(remu) rezet transpose(res)])
        residu = transpose([transpose(residu1) transpose(residu2)])
        residunorm = sqrt(transpose(residu) * residu)
        residumax = maximum(abs.(residu))

        ittt = 0
        while residumax > 0.9 * epsi && ittt < 100
            ittt = ittt + 1
            itera = itera + 1

            ux1 = upp - x
            xl1 = x - low
            ux2 = ux1 .* ux1
            xl2 = xl1 .* xl1
            ux3 = ux1 .* ux2
            xl3 = xl1 .* xl2
            uxinv1 = een ./ ux1
            xlinv1 = een ./ xl1
            uxinv2 = een ./ ux2
            xlinv2 = een ./ xl2
            plam = p0 + transpose(P) * lam
            qlam = q0 + transpose(Q) * lam
            gvec = P * uxinv1 + Q * xlinv1
            GG = P * spdiagm(n, n, 0 => uxinv2) - Q * spdiagm(n, n, 0 => xlinv2)
            dpsidx = plam ./ ux2 - qlam ./ xl2
            delx = dpsidx - epsvecn ./ (x - alfa) + epsvecn ./ (beta - x)
            dely = c + d .* y - lam - epsvecm ./ y
            delz = a0 - transpose(a) * lam - epsi / z
            dellam = gvec - a * z - y - b + epsvecm ./ lam
            diagx = plam ./ ux3 + qlam ./ xl3
            diagx = 2 * diagx + xsi ./ (x - alfa) + eta ./ (beta - x)
            diagxinv = een ./ diagx
            diagy = d + mu ./ y
            diagyinv = eem ./ diagy
            diaglam = s ./ lam
            diaglamyi = diaglam + diagyinv

            if m < n
                blam = dellam + dely ./ diagy - GG * (delx ./ diagx)
                bb = transpose([transpose(blam) delz])
                Alam = spdiagm(m, m, 0 => diaglamyi) + GG * spdiagm(n, n, 0 => diagxinv) * transpose(GG)
                AA = [Alam a;
                    transpose(a) -zet/z]
                solut = AA \ bb
                dlam = solut[1:m]
                dz = solut[m+1]
                dx = -delx ./ diagx - (transpose(GG) * dlam) ./ diagx
            else
                diaglamyiinv = eem ./ diaglamyi
                dellamyi = dellam + dely ./ diagy
                Axx = spdiagm(n, n, 0 => diagx) + transpose(GG) * spdiagm(m, m, 0 => diaglamyiinv) * GG
                azz = zet / z + transpose(a) * (a ./ diaglamyi)
                axz = -transpose(GG) * (a ./ diaglamyi)
                bx = delx + transpose(GG) * (dellamyi ./ diaglamyi)
                bz = delz - transpose(a) * (dellamyi ./ diaglamyi)
                AA = [Axx axz;
                    transpose(axz) azz]
                bb = transpose([-transpose(bx) -bz])
                solut = AA \ bb
                dx = solut[1:n]
                dz = solut[n + 1]
                dlam = (GG * dx) ./ diaglamyi - dz * (a ./ diaglamyi) + dellamyi ./ diaglamyi
            end

            dy = -dely ./ diagy + dlam ./ diagy
            dxsi = -xsi + epsvecn ./ (x - alfa) - (xsi .* dx) ./ (x - alfa)
            deta = -eta + epsvecn ./ (beta - x) + (eta .* dx) ./ (beta - x)
            dmu = -mu + epsvecm ./ y - (mu .* dy) ./ y
            dzet = -zet + epsi / z - zet * dz / z
            ds = -s + epsvecm ./ lam - (s .* dlam) ./ lam
            xx = transpose([transpose(y) z transpose(lam) transpose(xsi) transpose(eta) transpose(mu) zet transpose(s)])
            dxx = transpose([transpose(dy) dz transpose(dlam) transpose(dxsi) transpose(deta) transpose(dmu) dzet transpose(ds)])

            stepxx = -1.01 * dxx ./ xx
            stmxx = maximum(stepxx)
            stepalfa = -1.01 * dx ./ (x - alfa)
            stmalfa = maximum(stepalfa)
            stepbeta = 1.01 * dx ./ (beta - x)
            stmbeta = maximum(stepbeta)
            stmalbe = max.(stmalfa, stmbeta)
            stmalbexx = max.(stmalbe, stmxx)
            stminv = max.(stmalbexx, 1)
            steg = 1 / stminv

            xold = copy(x)
            yold = copy(y)
            zold = copy(z)
            lamold = copy(lam)
            xsiold = copy(xsi)
            etaold = copy(eta)
            muold = copy(mu)
            zetold = copy(zet)
            sold = copy(s)

            itto = 0
            resinew = 2 * residunorm
            while resinew[1] > residunorm[1] && itto < 50
                itto = itto + 1

                x = xold + steg * dx
                y = yold + steg * dy
                z = zold + steg * dz
                lam = lamold + steg * dlam
                xsi = xsiold + steg * dxsi
                eta = etaold + steg * deta
                mu = muold + steg * dmu
                zet = zetold + steg * dzet
                s = sold + steg * ds
                ux1 = upp - x
                xl1 = x - low
                ux2 = ux1 .* ux1
                xl2 = xl1 .* xl1
                uxinv1 = een ./ ux1
                xlinv1 = een ./ xl1
                plam = p0 + transpose(P) * lam
                qlam = q0 + transpose(Q) * lam
                gvec = P * uxinv1 + Q * xlinv1
                dpsidx = plam ./ ux2 - qlam ./ xl2

                rex = dpsidx - xsi + eta
                rey = c + d .* y - mu - lam
                rez = a0 - zet - transpose(a) * lam
                relam = gvec - a * z - y + s - b
                rexsi = xsi .* (x - alfa) - epsvecn
                reeta = eta .* (beta - x) - epsvecn
                remu = mu .* y - epsvecm
                rezet = zet * z - epsi
                res = lam .* s - epsvecm

                residu1 = transpose([transpose(rex) transpose(rey) rez])
                residu2 = transpose([transpose(relam) transpose(rexsi) transpose(reeta) transpose(remu) rezet transpose(res)])
                residu = transpose([transpose(residu1) transpose(residu2)])
                resinew = sqrt(dot(transpose(residu), residu))
                steg = steg / 2
            end
            residunorm = copy(resinew)
            residumax = maximum(abs.(residu))
            steg = 2 * steg
        end
        epsi = 0.1 * epsi
    end

    xmma = copy(x)
    ymma = copy(y)
    zmma = copy(z)
    lamma = copy(lam)
    xsimma = copy(xsi)
    etamma = copy(eta)
    mumma = copy(mu)
    zetmma = copy(zet)
    smma = copy(s)
    #-------------end of MMA--------------------------
    return xmma, ymma, zmma, lamma, xsimma, etamma, mumma, zetmma, smma
end

