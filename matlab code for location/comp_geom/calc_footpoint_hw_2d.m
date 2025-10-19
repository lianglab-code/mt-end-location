function [p, t] = calc_footpoint_hw_2d(bs,p0,varargin)
%% CALC_FOOTPOINT_HW calculates the foot point p of p0 on b-spline
% bs. Additionally, the parameter t is also provided.

% INPUT: 
% bs: b-spline, b-form
% p0: test point (dim 2x1)
% t0: initial parameter of the foot point

% OUTPUT:
% p: the foot point (the closest point)
% t: the parameter of the foot point

% REFERENCE:
% A second order algorithm for orthogonal projection onto curves
% and surfaces, Hu and Wallner, 2005

ts = bs.knots(1); % start
te = bs.knots(end); % end

if length(varargin)>0
    t0 = varargin{1};
else
    t0 = (ts+te)*.5;
end

end