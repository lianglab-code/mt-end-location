function imgs2 = img_correct_drift(imgs,cum_drifts)
%% IMG_CORRECT_DRIFT correts the drift by using the localization of
% a series of points.
% imgs2 = img_correct_drift(imgs,cum_drifts)
% Step 06 for registration of MT static images: correction of
% drifts

% INPUT:
% imgs: original images, or cropped images
% cum_drifts: 2xnum_frames, the drift relative to the first image 

% OUTPUT:
% img2: corrected images

% EXAMPLE:
% % params is the output of the img_track_dot
% xy = params(1:2,:,:);
% [drifts,cum_drifts] = img_calc_drift(xy);
% imgs2 = img_correct_drift(imgs,cum_drifts);

[img_h, img_w, num_frames] = size(imgs);

if num_frames ~= size(cum_drifts,2)
    error('mismatch: frame number and drift correction');
    return;
end

imgs2 = zeros(size(imgs));
T = [1, 0, 0;
     0, 1, 0;
     0, 0, 1];
for ii = 1:num_frames
    % T(3,1) = -real(cum_drifts(ii));
    % T(3,2) = -imag(cum_drifts(ii));
    T(3,1) = -cum_drifts(1,ii);
    T(3,2) = -cum_drifts(2,ii);
    tform = maketform('affine',T);
    imgs2(:,:,ii) = imtransform(...
        imgs(:,:,ii),...
        tform,...
        'XData',[1 img_w],...
        'YData',[1 img_h]...
        );
end
