# ===========
# Gradient of shape function matrix in parent coordinates
function G0_N(xi, eta, elem)
    Matrix = 0.25 * transpose([eta-1 xi-1;
        1-eta -xi-1;
        1+eta 1+xi;
        -eta-1 1-xi])
    return Matrix
end
