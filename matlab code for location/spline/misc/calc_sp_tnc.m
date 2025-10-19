function [tt,n,sc] = calc_sp_tnc(sp,t)
%% CALC_SP_NORMAL calculates the normal at the given
% parameters t

% INPUT:
% sp: b-spline
% t: 1xnp param

% OUTPUT:
% tt: 2 x np, tangent
% n: 2 x np, normalized
% sc: signed curvature, 1 x np

np = size(t,2);

knots = sp.knots;
k = sp.order;
t0 = knots(1);
t1 = knots(end);

spd = fnder(sp);
spdd = fnder(spd);

dy = fnval(spd,t);
ddy = fnval(spdd,t);

ds = sqrt(sum(dy.^2,1));
ds3 = ds.^3;

tt = dy./repmat(ds,2,1);
n = [0,-1;1,0]*tt;
n(1,(t<=t0)|(t>=t1)) = 0;
n(2,(t<=t0)|(t>=t1)) = 0;
tt(1,(t<=t0)|(t>=t1)) = 0;
tt(2,(t<=t0)|(t>=t1)) = 0;
sc = (dy(1,:).*ddy(2,:)-dy(2,:).*ddy(1,:))./ds3;
sc((t<=t0)|(t>=t1)) = 0;