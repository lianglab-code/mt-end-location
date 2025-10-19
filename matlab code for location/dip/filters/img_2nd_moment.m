function [lmax,lmin,theta] = img_2nd_moment(Dx,Dy,varargin)
%% IMG_2ND_MOMENT calculates the second image moment.
% [lmax,lmin,theta] = img_2nd_moment(Dx,Dy,[S])
%
% INPUT:
% Dx: dI/dx
% Dy: dI/dy
% S: scale
%
% OUTPUT:
% lmax: largest eignevalue
% lmin: smallest eignevalue
% theta: direction of vessel

I1 = Dx.*Dx;
I2 = Dx.*Dy;
I3 = Dy.*Dy;

S = 0;

if nargin > 2
    S = varargin{1};
end

if S>0
    I1 = filter_gauss_2d(I1,S);
    I2 = filter_gauss_2d(I2,S);
    I3 = filter_gauss_2d(I3,S);
end

tmp1 = I1+I3;
tmp2 = tmp1.^2 - 4*(I1.*I3-I2.*I2);
tmp3 = .5*(tmp1+sqrt(tmp2));
tmp4 = .5*(tmp1-sqrt(tmp2));

idx = abs(tmp3)>abs(tmp4);
lmax = tmp4;
lmax(idx) = tmp3(idx);
lmin = tmp3;
lmin(idx) = tmp4(idx);

% theta = atan(-I2./(I1-lmax));
% theta = theta + pi/2;
% theta = theta - pi*floor(theta*2/pi);

theta = atan(-I2./(I1-lmin));


