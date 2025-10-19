function g = construct_nng_epi(xy,epi)
%% CONSTRUCT_NNG_EPI constructs epsilon nearest-neighbor graph from
% the points xy by using the brute-de-force method, e.g, pdist
%
% INPUT:
% xy: dim x np
% epi: epsilon, distance threshold
%
% OUTPUT:
% g: adjacency matrix
%
% NOTE:
% the weight is the distance

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

d(d>epi) = 0;
ind = find(d);

I = zeros(1,np*(np-1)/2);
J = zeros(1,np*(np-1)/2);

for ii = 1:np
    for jj = (ii+1):np
        tmpi = (2*np-ii)*(ii-1)/2 + (jj-ii);
        I(tmpi) = ii;
        J(tmpi) = jj;
    end
end

g = sparse(I(ind),J(ind),d(ind),np,np);
g = max(g,g');

% TEST
% nz = 10;
% xy = rand(2,nz);
% epi = 0.2;
% g = construct_nng_epi(xy,epi);
% gplot(g,xy','ro-')
