function p = pline_ab(ps)
%% PLINE calculate the lines joining points in ps
% p = pline(ps)
% It mimics the built-in function pdist

% INPUT:
% ps: 2xnp

% OUTPUT:
% p: param, p(1)*x + p(2)*y = 1;

% EXAMPLE:
% ps = rand(2,100);
% p = pline_ab(ps);


[dim,np] = size(ps);

% parameters of a line
p =zeros(dim,np*(np-1)/2);

if dim~=2
    error('only 2d case is supported');
    return;
end

ONE = ones(dim,1);

ind = 1;
for ii = 2:np
    p1 = ps(:,ii);
    for jj = (ii+1):np
        p2 = ps(:,jj);
        dy = p2(2)-p1(2);
        dx = p2(1)-p1(1);
        if abs(dy)<100*eps && abs(dx)<100*eps
            warning('overlapped points appears');
            p(:,ind) = nan(dim,1);
        else
            M = [p1';p2'];
            p(:,ind) = M\ONE;
        end
        ind = ind+1;
    end
end
