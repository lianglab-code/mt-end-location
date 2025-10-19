function [x,y] = gen_circ(c,r,varargin)
%% GEN_CIRC generates lots of circles specified by centers and
% radius

% INPUT:
% c: centers, 2 x nc
% r: radius, 1 x nc

% OUTPUT:
% x: nc x np
% y: nc x np

% nc: number of circles
% np: number of points on a circle

% REFERENCE:
% Brett Shoelson's implementation circles.m

np = 50;
if nargin>2
    np = varargin{1};
end

if size(c,2)~=size(r,2)
    error('dimensions mismatch');
    return;
end

nc = size(c,2);
x = zeros(nc,np);
y = zeros(nc,np);

r = r.';
theta = 2*pi*linspace(0,1,np);
ct = cos(theta);
st = sin(theta);

x = bsxfun(@times, ct, r);
y = bsxfun(@times, st, r);
x = bsxfun(@plus,c(1,:)',x);
y = bsxfun(@plus,c(2,:)',y);
