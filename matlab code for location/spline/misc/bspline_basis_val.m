function Y = bspline_basis_val(T,K,J,X)
%% BSPLINE_BASIS_VAL calculates the value of the basis function at
% X. The order of the basis function is indicated by the number of
% input knot sequence T.

% INPUT:
% T: knot sequence. It determine the order of the basis function
% K: order of the spline
% J: the jth basis function, 1 x m
% X: X to be evaluated, 1 x n

% OUTPUT:
% Y: Y, m x n, y = B_j(x)

% REFERENCE:
% Carl de Boor, A Practical Guide to Splines, p90

% NOTE:
% It might be used to solve the problems in which the target
% function is represented/approximated by a b-spline.
% A simple implementation would use MATLAB's
% functions. Specifically, a b-spline is constructed by using
% spmak, and set the coefs to zeros except the corresponding jth
% element. Then the value of the corresponding basis at x can be
% obtained by using fnval(bs,x).
% Anyway, I give up... Or I will implement it later. TODO

num_j = prod(size(J));
num_x = prod(size(X));
num_knot = prod(size(T));

T = reshape(T,num_knot,1);
J = reshape(J,1,num_j);
X = reshape(X,1,num_x);
Y = zeros(num_j,num_x);

