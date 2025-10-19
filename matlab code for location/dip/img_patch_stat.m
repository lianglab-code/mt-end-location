function p_stat = img_patch_stat(p, sz_p, varargin)
%% IMG_PATCH_STAT calculates the statistics of image patches
% stat_struct = img_patch_stat(p, sz_p, frame)
% p and sz_p could be obtained from the function 
% img_patch

% INPUT:
% p: image patches
% sz_p: the size of the p matrix
% frame: frame index to be plotted

% OUTPUT:
% p_stat: the mean, std, median, min, max and quantile(0.8) of the patches

MAX_PATCH = 20000;
NUM_BIN = 100;
QUANTILE = 0.8;

H = sz_p(1);
W = sz_p(2);
num_frames = sz_p(3);
F = 1;
Oimg = 0; % offset
s = 0.0005; % spacing
h = (1-(H+1)*s)/H; % patch high
w = (1-(W+1)*s)/W; % patch width

if nargin>2
    F = varargin{1};
    Oimg = (F-1)*H*W;
end

if prod(sz_p)>MAX_PATCH
    error('too many patches!');
    return;
end

if size(p,3)>prod(sz_p)
    error('p and sz_p mismatch!');
    return;
end

p_stat = struct();
p_stat.mean = zeros(H*W,1);
p_stat.std = zeros(H*W,1);
p_stat.median = zeros(H*W,1);
p_stat.min = zeros(H*W,1);
p_stat.max = zeros(H*W,1);
p_stat.quantile = zeros(H*W,1);

for ii = 1:H
    for jj = 1:W
        img2 = p(:,:,Oimg+(jj-1)*H+ii);
        img2 = img2(:);
        p_stat.mean((jj-1)*H+ii) = mean(img2);
        p_stat.std((jj-1)*H+ii) = std(img2);
        p_stat.median((jj-1)*H+ii) = median(img2);
        p_stat.min((jj-1)*H+ii) = min(img2);
        p_stat.max((jj-1)*H+ii) = max(img2);
        p_stat.quantile((jj-1)*H+ii) = quantile(img2,QUANTILE);
    end
end