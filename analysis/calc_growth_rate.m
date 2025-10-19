function [vg, t] = calc_growth_rate(centers, nm_per_pixel, ...
                                    t_int, varargin)

%% CALC_GROWTH_RATE calculates the growth rate
% Unable to handle vertical lines
%% TODO

% Input:
% centers: complex vector, e.g., gb_mt_end_params.center
% nm_per_pixel
% t_int: time interval
% center_idx: logical vector for the center vector, ...
% center_idx is currently used in the first line fitting

% Output:
% vg: growth rate, nm/s
% t: time index

np = numel(centers);
center_idx = ones(np, 1);
vg = zeros(np, 1);
t = linspace(0, (np-1)*t_int, np);
t = t';

if(nargin>3)
    center_idx = varargin{1};
end

p = centers(center_idx);

% 1. calculate the line through the end points
A = linear_fit(real(p), imag(p)); % A(1)*x + A(2) = y

% 2. calculate the relative displacement
theta = atan(A(1));
rotated_centers = centers*(cos(-1*theta)+i*(sin(-1*theta)));
s = real(rotated_centers);
s = s-min(s); % relative displacement

% 3. multiple line segment fitting

% 4. calibration

end