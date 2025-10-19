function [uni_ind,dup_ind,isuniq] = classify_unique(ind)
%% CLASSIFY_UNIQUE classifies indx set into unique part and
% duplicated part.
% 
% Input:
% ind: vector of integer indices
%
% Output:
% uni_ind: vector of unique indices
% dup_ind: vector of duplicated indices
% isuniq: unique indicator vector for original vector
%
% See Also
% distance_cluster

    num_ind = numel(ind);
    if num_ind < 2
        uni_ind = 1;
        dup_ind = [];
        return;
    end

    [c,ia,ic] = unique(ind);
    num_unique = numel(c);
    count = zeros(num_unique,1);
    for ii = 1:num_ind
        count(ic(ii)) = count(ic(ii)) + 1;
    end
    tmpind = (count==1);
    uni_ind = c(tmpind);
    dup_ind = c(~tmpind);
    isuniq = tmpind(ic);
end
