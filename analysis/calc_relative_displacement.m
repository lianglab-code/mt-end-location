function dr = calc_relative_displacement(centers, varargin)
%% CALC_RELATIVE_DISPLACEMENT returns relative displacement from a
% series of mt ends.

% Assumption: The input series of center coordinates should be
% linear.

% Input:
% centers: complex vector, e.g., gb_mt_end_params.center
% varargin: nm_per_pixel
% nm_per_pixel

% Output:
% dr: relative displacement, unit: a.u. or nm if nm_per_pixel is
% given

nm_per_pixel = 1;

if(nargin>1)
    nm_per_pixel = varargin{1};
end

% 1. calculate the line through the end points
A = linear_fit(real(centers), imag(centers)); % A(1)*x + A(2) = y

% 2. calculate the relative displacement
theta = atan(A(1));
if(real(centers(end))<real(centers(1)))
    theta = theta + pi;
end
rotated_centers = centers*(cos(-1*theta)+i*(sin(-1*theta)));
dr = real(rotated_centers);
dr = dr-min(dr); % relative displacement

dr = dr*nm_per_pixel;

end