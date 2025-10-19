function img2 = image_rotate(img,theta,varargin)
%% IMAGE_ROTATE rotates the image clockwise along the image axis
%
% Input:
% img: 2d image
% theta: clockwise angle in radian
%
% Output:
% img2
%
% Note:
% similar to imrotate(img,theta_degree,'bicubic','crop')

    if ndims(img)>2
        error('only 2d image is supported');
        return;
    end

    [img_h,img_w] = size(img);
    img_ref = imref2d(size(img));
    cx = img_w/2 + 0.5;
    cy = img_h/2 + 0.5;
    T1 = [1 0 0; 0 1 0; -cx -cy 1];
    T2 = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1];
    T3 = [1 0 0; 0 1 0; cx cy 1];
    T = T1*T2*T3;
    tform = affine2d(T);
    img2 = imwarp(img,tform,'cubic','outputview',img_ref);

end
