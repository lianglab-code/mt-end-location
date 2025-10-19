function img = img_patch_synt(p,sz_p,varargin)
%% IMG_PATCH_SYNT merges patches into an image.
% img = img_patch(p, sz_p)
% 
% INPUT: 
% p: h*w*(H*W*num_frame), the order of the third dim: 
%    column-row-frame
% sz_p: size, s or [h w]; prod(sz_p) == size(p,3)

% OUTPUT:
% img: 2d image

[h,w,num_p] = size(p);

if ndims(sz_p)==1
    W = sz_p;
    H = sz_p;
    num_frames = 1;
elseif ndims(sz_p)==2
    W = sz_p(1);
    H = sz_p(2);
    num_frames = 1;
else
    W = sz_p(1);
    H = sz_p(2);
    num_frames = sz_p(3);
end

if W*H*num_frames ~= num_p
    error('patches number does not match the image size');
    return;
end

img_h = H*h;
img_w = W*w;
img = zeros(img_h,img_w,num_frames);

for ii = 1:num_frames
    o1 = (ii-1)*H*W; % offset 1
    for jj = 1:W
        o2 = (jj-1)*H; % offset 2
        js = (jj-1)*w+1;
        je = jj*w;
        for kk = 1:H
            hs = (kk-1)*h+1;
            he = kk*h;
            img(hs:he,js:je,ii) = p(:,:,o1+o2+kk);
        end
    end
end
