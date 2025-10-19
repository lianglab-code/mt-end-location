function [vmin,ind] = minnd(m)
%% MINND returns the min value vmin and its index as a row vector.
%  [vmin,ind] = minnd(m)

% INPUT:
% m: input matrix

% OUTPUT:
% vmin: minimum value
% ind: index row vector

% NOTE:
% source:
% https://cn.mathworks.com/matlabcentral/answers/63247-get-min-value-and-index-of-multidimensional-array
% https://cn.mathworks.com/matlabcentral/answers/263932-unknown-number-of-output-variables

sz_m = size(m);
len = prod(sz_m);

if len > 1e7
    error('matrix size too large!');
    return;
end

m = m(:);
[vmin, I] = min(m);
ind = cell(1,length(sz_m));
[ind{:}] = ind2sub(sz_m,I);
ind = cell2mat(ind);

