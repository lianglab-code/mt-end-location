function g = construct_nng_epi_theta(xy,t,epi,theta)
%% CONSTRUCT_NNG_EPI_THETA constructs epsilon nearest-neighbor graph from
% the points xy by using the brute-de-force method, e.g, pdist
%
% INPUT:
% xy: 2 x np
% t: 1 x np
% epi: distance scale
% theta: angle scale, rad
%
% OUTPUT:
% g: adjacency matrix
%
% NOTE:
% The weight of the edge is the similarity

EPI_TRUNC = 1;

if ndims(xy) ~= 2
    error('please input 2d matrix');
    return;
end

[dim,np] = size(xy);
if dim>np
    error('input should be of dimension dim x np');
    return;
end

% euclidean distance
d = pdist(xy');

d(d>(EPI_TRUNC*epi)) = 0;
g = spalloc(np,np,2*nnz(d));

for ii = 1:np
    for jj = (ii+1):np
        ind = (2*np-ii)*(ii-1)/2 + (jj-ii);
        if d(ind)==0
            continue;
        end
        t2 = abs(t(ii)-t(jj));
        if t2>pi/2
            t2 = pi-t2;
        end
        g(ii,jj) = exp(-d(ind)^2/(2*epi^2)) ...
            *exp(-t2^2/(2*theta^2));
        g(jj,ii) = g(ii,jj);
    end
end

% TEST
% nz = 10;
% xy = rand(2,nz);
% epi = 0.2;
% g = construct_nng_epi(xy,epi);
% gplot(g,xy','ro-')
