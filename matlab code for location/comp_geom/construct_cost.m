function c = construct_cost(p1,p2,cutoff,cost,varargin)
%% CONSTRUCT_COST constructs the cost matrix from two point sets
%
% Input:
% p1, p2: nx2 point sets (np1 and np2 points)
% cutoff: cutoff distance between points
% cost: cost of no matching
% cost2: forbidden cost
%
% Output:
% c: the cost matrix, (np1+np2)*(np1+np2)

    if nargin>4
        cost2 = varargin{1};
    else
        cost2 = 10*cost;
    end
    np1 = size(p1,1);
    np2 = size(p2,1);
    c11 = zeros(np1,np2);
    p1 = p1';
    p2 = p2';
    for ii = 1:np1
        c11(ii,:) = sqrt(sum((repmat(p1(:,ii),1,np2) - p2).^2,1));
    end
    c11(c11>cutoff) = cost2;
    c12 = cost*eye(np1);
    c12(c12~=cost) = cost2;
    c21 = cost*eye(np2);
    c21(c21~=cost) = cost2;
    % c22 = inf(np2,np1);
    c22 = c11';
    c = [c11,c12;c21,c22];
end
