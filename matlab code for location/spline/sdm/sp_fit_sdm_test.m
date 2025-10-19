function sp = sp_fit_sdm_test(pc, sp0, k, thres)
% is_open, l1, l2, max_iter)
%% SP_FIT_SDM fits point cloud pc with b-spline.

% INPUT:
% pc: point cloud
% sp0: initial b-spline
% thres: error threshold
% k: order of b-spline
% is_open: is the spline open
% l1: regulation term
% l2: regulation term
% max_iter: maximum iteration steps

% OUTPUT:
% sp: fitted b-spline

% references:
% 1. Fitting B-Spline Curves to Point Clouds by Curvature-Based
% Squared Distance Minimization, Wang, Pottmann and Liu
% 2. Implementation of fitting B-spline curves to point clouds by
% squared distance minimization, Pekelny
    
%% parameter setup
max_iter = 100;
l2 = 0.2;
l1 = 0.2;
is_open = false;

% 1. pre-computation
% 1.1 initiation of foot points


% 2. optimization
% 2.1 

% IT SEEMS THAT I SHOULD SOLVE THE SHOTEST PATH BETWEEN TWO POINTS
% FIRST

end