function [dist, tk] = calc_dist_p2bs_fine(pc, bs, init_tk)
%% CALC_DIST_P2BS_FINE calculates the distance for a point to a
%% b-spline given a guess foot-point tk

% INPUT:
% pc: point cloud, 2xn
% bs: b-spline
% init_tk: guess tk
% tol: tolerence
% max_iter: maximum iteration

% OUTPUT:
% dist: the distance, 1xn
% tk: the foot points, 1xn

% ASSUMPTIONS:
% 1. The knots are uniformly distributed
% 2. Closed curves have wrapped control points
% 3. The guess tk should be somehow close to the true tk

% EXAMPLE:
%
% PARAMETERS:
    NUM_TK = 100; % number of the coarse foot point, uniformly
                  % distributed
    tol = 1e-3; % tolerence
    max_iter = 20; % maximum iteration in the Newton algorithm
    
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
    tcoar = linspace(tstart, tend, NUM_TK);
end