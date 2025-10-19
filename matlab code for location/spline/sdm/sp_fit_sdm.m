function sp = sp_fit_sdm(pc, sp0, k, thres, varargin)
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
n_var = length(varargin);
if n_var < 4
    max_iter = varargin{4};
    if n_var < 3
        l2 = varargin{3};
        if n_var < 2
            l1 = varargin{2};
            if n_var < 1
                is_open = false;
            end
        end
    end
end

% 1. pre-computation
% 1.1 initiation of foot points


% 2. optimization
% 2.1 

% IT SEEMS THAT I SHOULD SOLVE THE SHOTEST PATH BETWEEN TWO POINTS
% FIRST

end