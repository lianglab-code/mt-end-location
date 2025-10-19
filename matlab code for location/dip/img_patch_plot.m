function h_fig = img_patch_plot(p, sz_p, varargin)
%% IMG_PATCH_PLOT plots the patches from one frame
% h_fig = img_patch_plot(p, sz_p, frame)
% p and sz_p could be obtained from the function 
% img_patch
% 
% INPUT:
% p: image patches
% sz_p: the size of the p matrix
% frame: frame index to be plotted
% 
% OUTPUT:
% h_fig: handle to the figure object

MAX_PATCH = 2000;

H = sz_p(1);
W = sz_p(2);
num_frames = sz_p(3);
F = 1;
Oimg = 0; % offset
s = 0.0005; % spacing
h = (1-(H+1)*s)/H; % sub-axis height for patch
w = (1-(W+1)*s)/W; % sub-axis width for patch

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

h_fig = figure;

img = p(:,:,(Oimg+1):(Oimg+H*W));
img = img(:);
img_min = min(img);
img_max = quantile(img,0.95);

for ii = 1:H
    for jj = 1:W
        pos = [ s+(jj-1)*(w+s), ...
                s+(H-ii)*(h+s), ...
                w, h ...
              ];
        % subplot(H, W, (ii-1)*W+jj, 'position', pos);
        subplot('position', pos);
        imshow(p(:,:,Oimg+(jj-1)*H+ii),[img_min, img_max]);
        % axis 'ij';
    end
end