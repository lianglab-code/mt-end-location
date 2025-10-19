function tangent = calc_sp_tangent(sp,t)
%% CALC_SP_TANGENT calculates the tangent at the given
% parameters t

% INPUT:
% sp: b-spline
% t: 1xnp param

% OUTPUT:
% tangent: 2 x np, normalized

np = size(t,2);

knots = sp.knots;
k = sp.order;
t0 = knots(1);
t1 = knots(end);

spd = fnder(sp);

dy = fnval(spd,t);
tmp = sqrt(sum(dy.^2,1));

tangent = dy./repmat(tmp,2,1);
tangent(1,(t<=t0)|(t>=t1)) = 0;
tangent(2,(t<=t0)|(t>=t1)) = 0;