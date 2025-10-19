function [xy2,t] = orient_line(xy)
%% ORIENT_LINE calculates the projection of the data to the
% principal directions

% INPUT:
% xy: NxP matrix, N samples, P dims
    
% OUTPUT:
% xy2: rotated data
% t: the index
    
    if ndims(xy) ~= 2
        error('please input 2D data');
        return;
    end
    [N,P] = size(xy);
    if N<P
        xy = xy';
    end
    
    t = find((sum(isnan(xy),2)==0));
    xy = xy(t,:);

    xy2 = bsxfun(@minus,xy,mean(xy,1));
    [U,S,V] = svd(xy2);
    xy2 = xy2*V;
    
end