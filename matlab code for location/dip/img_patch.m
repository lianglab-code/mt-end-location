function [p, sz_p] = img_patch(img, sz,varargin)
%% IMG_PATCH splits image img into small patches p with size sz.
% [p, sz_p] = img_patch(img, sz,[warning_off])
% 
% INPUT: 
% img: image or images
% sz: size, s or [h w];
% warning_off: false, default
% 
% OUTPUT:
% p: h*w*(H*W*num_frame), the order of the third dim: 
%    column-row-frame
% sz_p: size of the patch collection, [H, W, num_frame]

h = 0;
w = 0;
p = [];
sz_p = [];

if prod(size(sz))==1
    h = sz;
    w = sz;
elseif prod(size(sz))==2
    h = sz(1);
    w = sz(2);
else
    error('sz: wrong format');
    return;
end

if h*w<=0
    error('pls specify size of patch');
    return;
end

warning_off = false;
if nargin>2
    warning_off = varargin{1};
end

[img_h, img_w, num_frames] = size(img);

H = floor(img_h/h);
W = floor(img_w/w);
if ~warning_off
    if img_h>(H*h) || img_w>(W*w)
        warning('last parts of the image are ignored');
    end
end

p = zeros(h, w, H*W*num_frames);
sz_p = [H, W, num_frames];
for ii = 1:num_frames
    o1 = (ii-1)*H*W; % offset 1
    for jj = 1:W
        o2 = (jj-1)*H; % offset 2
        js = (jj-1)*w+1;
        je = jj*w;
        for kk = 1:H
            hs = (kk-1)*h+1;
            he = kk*h;
            p(:,:,o1+o2+kk) = img(hs:he,js:je,ii);
        end
    end
end
