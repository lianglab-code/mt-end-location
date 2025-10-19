function Cs = binary_to_curvesegment(bin_img,nng_r)
%% BINARY_TO_CURVESEGMENT constructs CurveSegment from a binary
% image. The CurveSegments are simple paths, will not intersect
% each other. 
%
% C = binary_to_curvesegment(bin_img,nng_r)
%
% Input:
% bin_img: binary image
% nng_r: radius for nearest-neighbor graph
%
% Output:
% Cs: cell of CurveSegment
%
% Requirement:
% construct_nng_epi
% decompose_mst
% > R2015b
% graph, minspantree, conncomp, degree, subgraph

% graph construction
[I,J] = find(bin_img);
if numel(I)==0
    Cs = {};
    return;
end

g = construct_nng_epi([J';I'],nng_r); % rnn network, without
                                           % angle info
% g2 = construct_nng_epi_theta([J';I'],T',nng_r,pi/6);
G = graph(g);
mst = minspantree(G,'type','forest');

% try to decompose the overlapping Cs
% 1. the intersection occurs at end + end
% 2. the intersection occurs at end + middle
% 3. the intersection occurs at middle + middle

[tree_no,tree_sz] = conncomp(mst);
num_trees = numel(tree_sz);

Cs = {}; % CurveSegment

% decomposition 2 and 3, after this step, MT might be broken
for ii = 1:num_trees
    inds = find(tree_no == ii);
    II = I(inds);
    JJ = J(inds);
    switch tree_sz(ii)
      case 1
        Cs{end+1} = CurveSegment(...
            [JJ(1);II(1)],...
            [JJ(1);II(1)],...
            [JJ(1),JJ(1);II(1),II(1)]);
      case 2
        Cs{end+1} = CurveSegment(...
            [JJ(1);II(1)],...
            [JJ(2);II(2)],...
            [JJ(1),JJ(2);II(1),II(2)]);
      case 3
        deg = degree(mst,inds); % graph func
        [sort_deg,sort_ind] = sort(deg,'ascend');
        Cs{end+1} = CurveSegment(...
            [JJ(sort_ind(1));II(sort_ind(1))],...
            [JJ(sort_ind(2));II(sort_ind(2))],...
            [JJ(sort_ind(1)),JJ(sort_ind(3)),JJ(sort_ind(2));...
             II(sort_ind(1)),II(sort_ind(3)),II(sort_ind(2))]...
            );
      otherwise
        submst = subgraph(mst,inds);
        ps = decompose_mst(submst);
        for jj = 1:numel(ps)
            p = ps{jj};
            Cs{end+1} = CurveSegment(...
                [JJ(p(1));II(p(1))],...
                [JJ(p(end));II(p(end))],...
                [reshape(JJ(p),[1,numel(p)]);...
                 reshape(II(p),[1,numel(p)])]...
                );
        end
    end
end
