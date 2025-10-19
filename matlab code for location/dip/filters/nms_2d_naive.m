function out = nms_2d_naive(img,varargin)
%% NMS_2D_NAIVE is a naive implementation of the non-local maximum
% suppression algorithm.
%
% Input:
% img: 2d image, M x N, non-negative
% r: radius, scalar or scale filed(M x N, NOT IMPLEMENTED)
% t: orientation field in radian, M x N
% 
% NOTE:
% Just like nms_1d_naive.m, multiple maxima are not suppressed

% angle tolerance
% ANGLE_TOL = pi/6;
ANGLE_TOL = pi/3;
SIN_ANGLE_TOL = sin(ANGLE_TOL);

[M,N] = size(img);
out = zeros(M,N);

r = 1;
if nargin>1
    r = varargin{1};
    if r<1
        return;
    end
end

if nargin<3 % simple nms_2d
    for ii = (r+1):(M-r)
        for jj = (r+1):(N-r)
            if img(ii,jj) == 0
                continue;
            end
            subimg = img((ii-r):(ii+r),(jj-r):(jj+r));
            if img(ii,jj) == max(subimg(:))
                out(ii,jj) = img(ii,jj);
            end
        end
    end
else % directional nms_2d
    t = varargin{2};
    [X,Y] = meshgrid(-r:r,-r:r);
    t0 = atan(Y./X);
    t0(r+1,r+1) = 0;
    for ii = (r+1):(M-r)
        for jj = (r+1):(N-r)
            if img(ii,jj) == 0
                continue;
            end
            inds = find(abs(sin(t0-t(ii,jj)))>SIN_ANGLE_TOL);
            % inds = find( (abs(t0 - t((ii-r):(ii+r),(jj-r):(jj+r))))>SIN_ANGLE_TOL );
            subimg = img((ii-r):(ii+r),(jj-r):(jj+r));
            if img(ii,jj) >= max(subimg(inds))
                out(ii,jj) = img(ii,jj);
            end
        end
    end
end
