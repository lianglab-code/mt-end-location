function k = calc_pp_curvature(pp,t)
%% CALC_CURVATURE calculates the curvature at points t.
%
% k = calc_curvature(pp,t)
%
% INPUT:
% pp: splines
% t: parameter vector
%
% OUTPUT:
% k: signed curvature

    k = zeros(size(t));

    if pp.dim ~= 2
        error('only 2d curve is supported');
        return;
    end

    pp1 = fnder(pp);
    pp2 = fnder(pp1);

    pp1v = fnval(pp1,t);
    pp2v = fnval(pp2,t);

    x1 = pp1v(1,:);
    y1 = pp1v(2,:);
    x2 = pp2v(1,:);
    y2 = pp2v(2,:);

    k = (x1.*y2-y1.*x2)./sqrt((x1.^2+y1.^2).^3);
end
