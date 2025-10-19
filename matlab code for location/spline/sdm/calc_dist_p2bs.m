function [dist, tk] = calc_dist_p2bs(pc, bs, g)
%% CALC_DIST_P2BS calculates the distance for a point to a b-spline

% INPUT:
% pc: point cloud, 2xn
% bs: b-spline
% g: coarse grid

% OUTPUT:
% dist: the distance, 1xn
% tk: the foot points, 1xn

% ASSUMPTIONS:
% 1. The knots are uniformly distributed
% 2. Closed curves have wrapped control points

% REFERENCE:
% p226, "Fitting B-spline curves to point clouds by curvature-based
% squared distance minimization"

% EXAMPLE:
%
% PARAMETERS:
    NUM_TK = 100; % number of the coarse foot point, uniformly
                  % distributed
    
    % b-spline info
    k = bs.order;
    knots = bs.knots;
    cp = bs.coefs;
    % is the curve closed?
    tmp = cp(:,1:(k-1))-cp(:,(end-(k-2)):end);
    if sum(abs(tmp(:))) < 1e3*eps
        is_closed = true;
    else
        is_closed = false;
    end
    
    % generation of coarse foot point
    tstart = knots(k);
    tend = knots(end-k+1);
    tseq = linspace(tstart, tend, NUM_TK);
    sp_val = 
end