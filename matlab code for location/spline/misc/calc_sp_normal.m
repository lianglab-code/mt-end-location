function n = calc_sp_normal(sp,t)
%% CALC_SP_NORMAL calculates the normal at the given
% parameters t

% INPUT:
% sp: b-spline
% t: 1xnp param

% OUTPUT:
% normal: 2 x np, normalized

np = size(t,2);

knots = sp.knots;
k = sp.order;
t0 = knots(1);
t1 = knots(end);

spd = fnder(sp);

dy = fnval(spd,t);
tmp = sqrt(sum(dy.^2,1));

tangent = dy./repmat(tmp,2,1);
n = [0,-1;1,0]*tangent;
n(1,(t<=t0)|(t>=t1)) = 0;
n(2,(t<=t0)|(t>=t1)) = 0;