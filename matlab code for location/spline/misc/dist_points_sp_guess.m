function [d,t] = dist_points_sp_guess(ps,sp,t_guess)
%% DIST_POINTS_SP_BRUTE calculates the distance from each point p
% of a point set ps to a curve sp

% INPUT:
% ps: points, dim x np
% sp: b-spline
% t_guess: guess param corresponding to the closest point, 1 x np
%          the output of the dist_points_sp_brute can be used.

% OUTPUT:
% d: distance, 1xnp
% t: the corresponding point on the b-spline curve, 1xnp

% METHOD:
% The values at some points are evaluated, and the closest point in the
% set is picked out. This point is used as an initial guess of the
% Newton root (of the y below) finding method.

% ASSUMPTION:
% The domain is [knots(k) knots(end-k+1)].
% Curvature is small.
% The guess should be close enough, and the change of the b-spline
% should be small too, very small!!! This makes the program
% useless.

tol = 1e-4;
newton_iter_max = 30;
% factor = 10;
factor = 20;

k = sp.order;
knots = sp.knots(k:end-k+1);
num_knots = numel(knots);
knots = linspace(knots(1),knots(num_knots),factor*num_knots);
num_knots = numel(knots);

np = size(ps,2);
d = zeros(1,np);
t = zeros(1,np);

spd = fnder(sp); % 1st derivative
spdd = fnder(spd); % 2nd derivative
val_knots = fnval(sp,knots);

dknot = knots(2)-knots(1);

for jj = 1:np
    p = ps(:,jj);
    x = t_guess(jj);
    x0 = x - dknot;
    x1 = x + dknot;
    if x <= knots(1)
        x = knots(1) + dknot/2;
        x0 = knots(1);
        x1 = knots(2);
    elseif x >= knots(num_knots)
        x = knots(num_knots) - dknot/2;
        x0 = knots(num_knots-1);
        x1 = knots(num_knots);
    else
        if x0 < knots(1)
            x0 = knots(1);
        end
        if x1 > knots(num_knots)
            x1 = knots(num_knots);
        end
    end
    
    val = fnval(sp,x);
    vald = fnval(spd,x);
    valdd = fnval(spdd,x);
    y = sum((val-p).*vald); % y(x) = (r-p){\cdot}r'

    for ii = 1:newton_iter_max
        if x<x0
            d(jj) = sqrt(sum((fnval(sp,x0)-p).^2));
            t(jj) = x0;
            break;
        elseif x>x1
            d(jj) = sqrt(sum((fnval(sp,x1)-p).^2));
            t(jj) = x1;
            break;
        elseif abs(y)<tol
            d(jj) = sqrt(sum((val-p).^2));
            t(jj) = x;
            break;
        else
            % dy/dx = r'{\cdot}r' + (r-p){\cdot}r''
            dydx = sum(vald.*vald) + sum((val-p).*valdd);
            x = x - y/dydx;
            val = fnval(sp,x);
            vald = fnval(spd,x);
            valdd = fnval(spdd,x);
            y = sum((val-p).*vald); % y(x) = (r-p){\cdot}r'
        end
    end
    if ii==newton_iter_max
        warning(['point number ',num2str(jj),': max newton iteration reached']);
        d(jj) = sqrt(sum((val-p).^2));
        t(jj) = x;
    end
end