function sc = calc_sp_curvature(sp,t)
%% CALC_SP_CURVATURE calculates the curvature at the given
% parameters t

% INPUT:
% sp: b-spline
% t: 1 x np param

% OUTPUT:
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

ds3 = sqrt(sum(dy.^2,1));
ds3 = ds3.^3;

sc = (dy(1,:).*ddy(2,:)-dy(2,:).*ddy(1,:))./ds3;
sc((t<=t0)|(t>=t1)) = 0;
