function p = pline_rt(ps)
%% PLINE calculate the lines joining points in ps
% p = pline(ps)
% It mimics the built-in function pdist

% INPUT:
% ps: 2xnp

% OUTPUT:
% p: param, p(1)*x + p(2)*y = 1;
% rho > 0
% -pi< theta <=pi

% EXAMPLE:
% ps = rand(2,100);
% p = pline_rt(ps);

% NOTE:
% Given rho0, theta0, a line is represented by:
% rho*cos(theta-theta0) = rho0
% Given (x1,y1) and (x2,y2), line is represented by:
% [x;y] = [x2;y2] + t*[x1-x2;y1-y2];
% and the intersection between this line the line originated from
% the origin which is perpendicular to this line is [x;y] at t:
% t = (x2*(x2-x1)+y2*(y2-y1))/((x1-x2)^2+(y1-y2)^2).

[dim,np] = size(ps);

% parameters of a line
p =zeros(dim,np*(np-1)/2);

if dim~=2
    error('only 2d case is supported');
    return;
end

ZERO = zeros(dim,2);

ind = 1;
for ii = 2:np
    p1 = ps(:,ii);
    for jj = (ii+1):np
        p2 = ps(:,jj);
        dp = p2-p1;
        if sum(dp.^2)<10000*eps
            warning('overlapped points appears');
            p(:,ind) = nan(dim,1);
        else
            t = sum(p2.*dp)/(sum(dp.^2));
            M = p2 - t*dp;; % intersection
            p(1,ind) = sqrt(M(1)^2+M(2)^2);
            p(2,ind) = atan2(M(2),M(1));
        end
        ind = ind+1;
    end
end
