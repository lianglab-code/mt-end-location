function [vmax,ind] = maxnd(m)
%% MAXND returns the max value vmax and its index as a row vector.
%  [vmax,ind] = maxnd(m)

% INPUT:
% m: input matrix

% OUTPUT:
% vmax: maximum value
% ind: index row vector

% NOTE:
% source:
% https://cn.mathworks.com/matlabcentral/answers/63247-get-max-value-and-index-of-multidimensional-array
% https://cn.mathworks.com/matlabcentral/answers/263932-unknown-number-of-output-variables
% The second link contains a hack to return multiple output as an array. It uses comma separatedlists

sz_m = size(m);
len = prod(sz_m);

if len > 1e7
    error('matrix size too large!');
    return;
end

m = m(:);
[vmax, I] = max(m);
ind = cell(1,length(sz_m));
[ind{:}] = ind2sub(sz_m,I);
ind = cell2mat(ind);

