function [kimg,ln] = kymograph(imgs,p1,p2,varargin)
%% KYMOGRAPH plot the kymograph along the line segment from p1 to
% p2.
% kimg = kymograph(imgs,p1,p2,varargin)
%
% INPUT:
% imgs: images
%     : img_h * img_w * num_frames or
%     : img_h * img_w * num_channels * num_frames
% p1: [x1;y1]
% p2: [x2;y2]
% n: number of points along the line segment, default 100
% w: width of the line segment, default 0
%
% OUTPUT:
% kimg: the kymograph
%     : num_frames * n, if single channel
%     : num_frames * n * num_channels, if multiple channels
% ln  : 2 x n; the coordinates along the line

n = 100;
w = 0;
kimg = [];

if nargin>3
    n = varargin{1};
    if nargin>4
        w = varargin{2};
    end
end

img_h = 0;
img_w = 0;
num_frames = 1;
num_channels = 1;

dim = numel(size(imgs));
if dim==2
    error('only one slice, abort');
    return;
elseif dim==3
    [img_h,img_w,num_frames] = size(imgs);
    kimg = zeros(num_frames,n);
elseif dim==4
    [img_h,img_w,num_channels,num_frames] = size(imgs);
    kimg = zeros(num_frames,n,num_channels);
else
    error('wrong image format, abort');
    return;
end

x1 = p1(1);
y1 = p1(2);
x2 = p2(1);
y2 = p2(2);
ln = [linspace(x1,x2,n);linspace(y1,y2,n)];

if (x1-1)*(x1-img_w)>0 ||...
        (y1-1)*(y1-img_h)>0 ||...
        (x2-1)*(x2-img_w)>0 ||...
        (y2-1)*(y2-img_h)>0
    error('start and stop point out of bound, abort');
    return;
end

if dim==3 % single channel
    for ii = 1:num_frames
        kimg(ii,:) = my_line_profile(...
            imgs(:,:,ii),...
            [x1;x2],...
            [y1;y2],...
            w,...
            n);
    end
else % multiple channels
    for ii = 1:num_frames
        for jj = 1:num_channels
            kimg(ii,:,jj) = my_line_profile(...
                imgs(:,:,jj,ii),...
                [x1;x2],...
                [y1;y2],...
                w,...
                n);
        end
    end
end