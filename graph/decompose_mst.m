function p = decompose_mst(mst)
%% DECOMPOSE_MST decomposes mst to simple paths
% 
% p = decompose_mst(mst)
%
% INPUT:
% mst: one connected minimum-spanning tree
%
% OUTPUT:
% p: cell of vector of points representing simple paths, a
%    simple path is a path whose nodes have at most 2 degrees 
%
% REQUIREMENT:
% R2015b
% degree, numnodes, dfsearch

p = {};

d = degree(mst);
[maxdeg,maxnode] = max(d);

% only 1 path
if maxdeg<3
    [mindeg,minnode] = min(d);
    dfs = dfsearch(mst,minnode);
    p{end+1} = dfs;
    return;
end

% otherwise
% event point: when end nodes or branch nodes are encountered, a
% path is initiated or terminated.

dfs = dfsearch(mst,maxnode);

% start of the path
s = zeros(sum(d>2),1);
s(1) = maxnode; 
% degree of the start node
ds = zeros(size(s));
ds(1) = 1;
% current index of s
sind = 1;

v = [s(sind)]; % node of the path
for ii = 2:numnodes(mst)
    c = dfs(ii); % current node
    if d(c) == 2
        v(end+1) = c;
    elseif d(c) == 1
        v(end+1) = c;
        p{end+1} = v;
        % traverse to proper level in the tree
        for jj = sind:-1:1
            if ds(jj) < d(s(jj))
                ds(jj) = ds(jj)+1;
                break;
            end
        end
        sind = jj;
        v = [s(sind)];            
    elseif d(c) > 2
        v(end+1) = c;
        p{end+1} = v; % a complete path
        sind = sind + 1; % update the branch index
        s(sind) = c; % update current branch node
        v = [s(sind)];
        ds(sind) = 2; % degree of current branch node
    end
end
