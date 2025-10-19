function out = filter_minmax_1d(in,mode,r)
%% FILTER_MINMAX_1D calculates the min/max in a window with
% diameter r
% out = filter_minmax_1d(in,mode,r)

%% INPUT:
% in: input vector
% mode: 'min' or 'max'
% r: window half-size

%% OUTPUT:
% out: min/max filtered output

%% REFERENCE:
% Herk, A fast algorithm for local minimum and maximum filters on
% rectangular and octagonal kernels

%% NOTE:
% set test_vector_order.m for the execution order of loop

mode = lower(mode);

if strcmp(mode,'max')
    in = -in;
elseif strcmp(mode,'min')
    % default mode
else
    error('mode must be max or min');
    return;
end

[H,W] = size(in);
if H==1
    d = 2;
elseif W==1
    d = 1;
else
    error('1d input is required');
    return;
end

n = H*W;
k = 2*r+1; % window size

nseg = floor(n/k); % number of segments
rema = n - nseg*k; % remainder

% column vector processing
in2 = reshape(in,[n,1]);

% padding
if rema~=0
    % padding direction
    in2 = padarray(in2,[k-rema,0],inf,'post');
    nseg = nseg + 1;
    n = k*nseg;
end

in2 = reshape(in2,[k,nseg]);
g = zeros(size(in2));
h = zeros(size(in2));
g(1,:) = in2(1,:);
h(k,:) = in2(k,:);

for jj = 1:nseg
    for ii = 2:k
        g(ii,jj) = min(g(ii-1,jj),in2(ii,jj));
        h(k-ii+1,jj) = min(h(k-ii+2,jj),in2(k-ii+1,jj));
    end
end

for ii = 1:r
    in2(ii) = min(in2(1:(ii+r)));
    in2(n-ii+1) = min(in2((n-ii+1-r):(n)));
end
for ii = (r+1):(n-r)
    in2(ii) = min(g(ii+r),h(ii-r));
end

% in2 = reshape(in2,[1,n]);
out = reshape(in2(1:(H*W)),[H,W]);

if strcmp(mode,'max')
    out = -out;
end

