function [imgout, idx2, aligned] = smooth_by_center_alignment(imgin, ...
                                                      centers, ...
                                                      crop_radius, ...
                                                      scaling, ...
                                                      varargin)
%% SMOOTH_BY_CENTER_ALIGNMENT obtains smoothed images by aligning
% sub-images around given centers.

% Assumption: 
% the sub-images around centers have same structures.
% number of frames is equal to number of centers

% Input:
% imgin: input image series
% centers: complex vector, e.g., gb_mt_end_params.center
% crop_radius: radius of the cropped images (px)
% scaling: the subdivision of a pixel

% Output:
% imgout: smoothed image, size:(2*crop_radius+1)*scaling
% idx2: index of the aligned frames
% aligned: the aligned sub-images

[M, N, L] = size(imgin);

dirs = zeros(L,1);
if(nargin>4)
    dirs = varargin{1};
end

idx = ~isnan(centers);
np = sum(idx);
idx2 = idx; % used to check if all cropping inside the image

x = real(centers);
y = imag(centers);
xint = round(x);
yint = round(y);
dx = x-xint;
dy = y-yint;

% processing
r = crop_radius;
sc = 2*r+1; % crop size
dx = dx*scaling;
dy = dy*scaling;
            % dx = dx/scaling;
            % dy = dy/scaling;
aligned = zeros(scaling*sc, scaling*sc, L);
imgout = zeros(scaling*sc, scaling*sc);

for jj = 1:L
    tx = xint(jj);
    ty = yint(jj);
    % center ok?
    if(~idx(jj))
        continue;
    end
    % near boundary?
    if (tx<(r+1) || ty<(r+1) || (tx+r)>N || (ty+r)>M)
        idx2(jj) = false;
        continue;
    end
    % cropping
    cropped = imgin((ty-r):(ty+r), ...
                    (tx-r):(tx+r), ...
                    jj);
    % rescaling
    rescaled = imresize(cropped, scaling);
    % translating
    t_translate = eye(3);
    t_translate(3,1) = dx(jj);
    t_translate(3,2) = dy(jj);
    tform = maketform('affine',t_translate);
    aligned(:,:,jj) = imtransform(rescaled, tform, ...
                                  'XData', [1 scaling*sc], ...
                                  'YData', [1 scaling*sc]);
    if(dirs(jj)~=0)
        theta_deg = dirs(jj)*180/pi;
        aligned(:,:,jj) = imrotate(aligned(:,:,jj), ...
                                   theta_deg, ...
                                   'bicubic', ...
                                   'crop');
    end
    imgout = imgout + aligned(:,:,jj);
end

imgout = imgout/sum(idx2);

end

