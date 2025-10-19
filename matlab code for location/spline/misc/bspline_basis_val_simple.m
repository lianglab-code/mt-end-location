function Y = bspline_basis_val_simple(SP,J,X)
%% BSPLINE_BASIS_VAL calculates the value of the basis function at
% X. The order of the basis function is indicated by the number of
% input knot sequence T.

% INPUT:
% SP: b-spline
% J: the jth basis function, 1 x m
% X: X to be evaluated, 1 x n

% OUTPUT:
% Y: Y, m x n, y = B_j(x)

% NOTE:
% It might be used to solve the problems in which the target
% function is represented/approximated by a b-spline.
% A simple implementation would use MATLAB's
% functions. Specifically, a b-spline is constructed by using
% spmak, and set the coefs to zeros except the corresponding jth
% element. Then the value of the corresponding basis at x can be
% obtained by using fnval(bs,x).

num_j = prod(size(J));
num_x = prod(size(X));

num_coefs = size(SP.coefs,2);
knots = SP.knots;

flag = (J<1) | (J>num_coefs);
if sum(flag) ~= 0
    error('basis function index out of bound');
    return;
end

sp = spmak(knots, zeros(1,num_coefs));

J = reshape(J,1,num_j);
X = reshape(X,1,num_x);
Y = zeros(num_j,num_x);

for ii = 1:num_j
    coefs = zeros(1,num_coefs);
    coefs(J(ii)) = 1;
    sp.coefs = coefs;
    Y(ii,:) = spval(sp,X);
end