function [r1,r2,r3] = calc_error(sp,dcoef,l1,l2)
%% CALC_ERROR calculates the residuals of the optimization problem
% Specifically, the residues = sigma(d^2) + l1*F1 + l2*F2,
% where d are the distances from the point cloud to the b-spline
% curve, F1 = int{||P'||_2^2}dt, and F2 = int{||P''||_2^2}dt.

% INPUT:
% sp: b-spline
% dcoefs: displacements of the control points
% l1: regularization coef for F1
% l2: regularization coef for F2

% OUTPUT:
% r1: residuals of the distance
% r2: l1*F1
% r3: l2*F2

% TODO:
% to read LIU Yang's paper to find out the formula for the distance
% residuals for a small control point displacements.`