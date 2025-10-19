function theta = pdirec(ps)
%% PDIREC calculate the direction of lines joining points in ps
% theta = pdirec(ps)
% It mimics the built-in function pdist

% INPUT:
% ps: 2xnp

% OUTPUT:
% theta: direction, in rad

% EXAMPLE:
% ps = rand(2,100);
% theta = pdirec(ps);
% triud = vec2triu(theta,1);
% triud = (triud.'+triud)/2;
% for ii = 1:100
%     triud(ii,ii) = nan;
% end

[dim,np] = size(ps);

% vector of direction
theta = zeros(1,np*(np-1)/2);

if dim~=2
    error('only 2d case is supported');
    return;
end

ind = 1;
for ii = 2:np
    p1 = ps(:,ii);
    for jj = (ii+1):np
        p2 = ps(:,jj);
        dy = p2(2)-p1(2);
        dx = p2(1)-p1(1);
        if abs(dy)<100*eps && abs(dx)<100*eps
            error('no overlapped points are allowed');
            return;
        end
        theta(ind) = atan(dy/dx);
        ind = ind+1;
    end
end
