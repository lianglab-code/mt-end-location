function ind = distance_cluster(ps,epi)
%% DISTANCE_CLUSTER clusters point set within a radius epi
%
% Input:
% ps: points, dim x np
% epi: radius
%
% Output:
% ind: cluster index
% 
% See Also:
% classify_unique

    [dim,np] = size(ps);
    if dim > np
        warnint('dim>np, wrong format of ps?');
    end

    % construct graph
    g = construct_nng_epi(ps,epi);
    G = graph(g);
    ind = conncomp(G);

end
