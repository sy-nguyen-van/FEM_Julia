# ===========
function Jacobian8(xi, eta, zeta, elem,coords,elem_node)
    Matrix = 0.125 * transpose([-(1 - zeta)*(1-eta) -(1 - zeta)*(1-xi) -(1 - eta)*(1-xi);
                 (1-zeta)*(1-eta) -(1 - zeta)*(1+xi) -(1 - eta)*(1+xi);
                 (1-zeta)*(1+eta) (1-zeta)*(1+xi) -(1 + eta)*(1+xi);
                 -(1 - zeta)*(1+eta) (1-zeta)*(1-xi) -(1 + eta)*(1-xi);
                 -(1 + zeta)*(1-eta) -(1 + zeta)*(1-xi) (1-eta)*(1-xi);
                 (1+zeta)*(1-eta) -(1 + zeta)*(1+xi) (1-eta)*(1+xi);
                 (1+zeta)*(1+eta) (1+zeta)*(1+xi) (1+eta)*(1+xi);
                 -(1 + zeta)*(1+eta) (1+zeta)*(1-xi) (1+eta)*(1-xi)]) *
             transpose(coords[:, elem_node[:, elem]])

    return Matrix

end
