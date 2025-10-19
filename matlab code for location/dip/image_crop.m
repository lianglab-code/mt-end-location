function crop = image_crop(img,roi,varargin)
%% IMAGE_CROP crops a region out ot an image
%
% Input:
% img: 2d OR 3d image
% roi: ROI, [x1,x2,y1,y2] OR [x1,x2,y1,y2,z1,z2]
%      x1<=x2, y1<=y2, z1<=z2, int
%
% Output:
% crop: image crop
%
% Optional Input:
% F: filled in value

    if nargin>2
        F = varargin{1};
    else
        F = 0;
    end

    % DIMENSION CHECK
    dim = ndims(img);
    num_frames = 1;
    tmp_dim = numel(roi);
    if dim ~= (tmp_dim/2)
        error('dim mismatch');
        return;
    end

    if dim == 2
        tmp = num2cell(roi);
        [x1,x2,y1,y2] = tmp{:};
        z1 = 1; z2 = 1;
        [img_h,img_w] = size(img);
    elseif dim == 3
        tmp = num2cell(roi);
        [x1,x2,y1,y2,z1,z2] = tmp{:};
        [img_h,img_w,num_frames] = size(img);
    else
        error('higher than 3 dim image is not supported');
        return;
    end

    % BOUND CHECK
    if x1>x2 || y1>y2 || z1>z2
        error('roi out of bound');
        return;
    end
    
    if x1>img_w || x2<1 ...
            || y1>img_h || y2<1 ...
            || z1>num_frames || z2<1
        error('roi out of bound');
        return;
    end

    % BEGIN
    H = y2-y1+1; % height
    W = x2-x1+1; % width
    D = z2-z1+1; % depth
    crop = ones(H,W,D,'like',img)*F;

    % ORIGINAL IMAGE COORD
    if x1<1, u1=1; else u1=x1; end
    %
    if x2>img_w, u2=img_w; else u2=x2; end
    %
    if y1<1, v1=1; else v1=y1; end
    %
    if y2>img_h, v2=img_h; else v2=y2; end
    %
    if z1<1, w1=1; else w1=z1; end
    %
    if z2>num_frames, w2=num_frames; else w2=z2; end

    % CROP IMAGE COORD
    uu1 = 1+(u1-x1);
    uu2 = W-(x2-u2);
    %
    vv1 = 1+(v1-y1);
    vv2 = H-(y2-v2);
    %
    ww1 = 1+(w1-z1);
    ww2 = D-(z2-w2);
    %

    % OUTPUT
    crop(vv1:vv2,uu1:uu2,ww1:ww2) = img(v1:v2,u1:u2,w1:w2);

end

