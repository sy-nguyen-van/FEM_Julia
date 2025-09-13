# ===========
function G0_N8(xi, eta, zeta, elem)
    Matrix = 0.125 * transpose([-(1 - zeta)*(1-eta) -(1 - zeta)*(1-xi) -(1 - eta)*(1-xi);
        (1-zeta)*(1-eta) -(1 - zeta)*(1+xi) -(1 - eta)*(1+xi);
        (1-zeta)*(1+eta) (1-zeta)*(1+xi) -(1 + eta)*(1+xi);
        -(1 - zeta)*(1+eta) (1-zeta)*(1-xi) -(1 + eta)*(1-xi);
        -(1 + zeta)*(1-eta) -(1 + zeta)*(1-xi) (1-eta)*(1-xi);
        (1+zeta)*(1-eta) -(1 + zeta)*(1+xi) (1-eta)*(1+xi);
        (1+zeta)*(1+eta) (1+zeta)*(1+xi) (1+eta)*(1+xi);
        -(1 + zeta)*(1+eta) (1+zeta)*(1-xi) (1+eta)*(1-xi)])
    return Matrix
end