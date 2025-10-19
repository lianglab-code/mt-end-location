function mat = plot_circle(r,cx,cy,M,N,varargin)
%% PLOT_CIRCLE plots a circle in a matrix.
% mat = plot_circle(r,cx,cy,M,N,v)
%
% Input:
% r,cx,cy: radius, center
% M,N: matrix size, MxN
% v: filled value
%
% Output:
% mat: 2d matrix
%
% Method used:
% After choosing an angle theta, calculate the coordinates along
% the circle every theta.

v = 1;
if nargin>5
    v = varargin{1};
end

mat = zeros(M,N);

if r<1
    % couldn't handle circles tooooo small
    return;
end
% theta = 2*asin(.5/r);
theta = asin(.5/r);
thetas = linspace(0,pi*2,ceil(pi*2/theta));

x = round(cx + r*cos(thetas));
y = round(cy + r*sin(thetas));

% delete out-of-range points
inds = (x>0) & (x<N) & (y>0) & (y<M);

% coordinates to indices
% inds2 = sub2ind([M,N],x(inds),y(inds));
inds2 = sub2ind([M,N],y(inds),x(inds));

% fill the matrix
mat(inds2) = v;
