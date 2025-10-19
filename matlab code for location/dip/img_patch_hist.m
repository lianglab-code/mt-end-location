function [h_fig, p_hist, X] = img_patch_hist(p, sz_p, varargin)
%% IMG_PATCH_HIST plots the histogram of the patches in frame
% h_fig = img_patch_hist(p, sz_p, frame)
% p and sz_p could be obtained from the function 
% img_patch

% INPUT:
% p: image patches
% sz_p: the size of the p matrix
% frame: frame index to be plotted
% axis_on_off: default 'off'

% OUTPUT:
% h_fig: handle to the figure object
% p_hist: the historgram of the patches, NUM_PATCH*NUM_BIN
% X: the histogram bin

MAX_PATCH = 2000;
NUM_BIN = 100;

H = sz_p(1);
W = sz_p(2);
num_frames = sz_p(3);
s = 0.0005; % spacing
h = (1-(H+1)*s)/H; % sub-axis height for patch
w = (1-(W+1)*s)/W; % sub-axis width for patch

F = 1; % frame to be plot
Oimg = 0; % offset
axis_on_off = 'off';

if nargin>2
    F = varargin{1};
    Oimg = (F-1)*H*W;
    if nargin>3
        axis_on_off = lower(varargin{2});
    end
end

if prod(sz_p)>MAX_PATCH
    error('too many patches!');
    return;
end

if size(p,3)>prod(sz_p)
    error('p and sz_p mismatch!');
    return;
end

h_fig = figure;
p_hist = zeros(H*W,NUM_BIN);

img = p(:,:,(Oimg+1):(Oimg+H*W));
img = img(:);
img_min = min(img);
img_max = quantile(img,0.95);
X = linspace(img_min, img_max, NUM_BIN);

for ii = 1:H
    for jj = 1:W
        pos = [ s+(jj-1)*(w+s), ...
                s+(H-ii)*(h+s), ...
                w, h ...
              ];
        % subplot(H, W, (ii-1)*W+jj, 'position', pos);
        subplot('position', pos);
        img2 = p(:,:,Oimg+(jj-1)*H+ii);
        img2 = img2(:);
        Y=hist(img2,X);
        p_hist((jj-1)*H+ii,:) = Y;
        bar(X,Y);
        if(strcmp(axis_on_off,'off'))
            axis off;
        else
            axis([X(1) X(end) min(Y) max(Y)]);
        end
        % axis 'ij';
    end
end