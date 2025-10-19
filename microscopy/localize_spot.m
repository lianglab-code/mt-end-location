function xyt = localize_spot(imgs,xyt0)
%% LOCALIZE SPOT localizes spots around xy0 by fitting a 2d
% gaussian.
%
% Input:
% imgs: image sereis
% xyt0: np x 3
% 
% Output:
% xyt: np x 3
% 
% TODO:
% To change xy0 to params which includes other params
%

    SIGMA0 = 2;
    CROP_RADIUS = 3*SIGMA0;

    [img_h, img_w, num_frames] = size(imgs);
    np = size(xyt0,1);
    xyt = nan(np,3);
    image_mean = mean(imgs(:)); % to pad the cropped image

    % processing
    xyt1 = round(xyt0);
    for ii = 1:np
        t = xyt1(ii,3);
        x0 = xyt1(ii,1);
        y0 = xyt1(ii,2);
        roi = [x0-CROP_RADIUS,...
               x0+CROP_RADIUS,...
               y0-CROP_RADIUS,...
               y0+CROP_RADIUS];
        crop = image_crop(imgs(:,:,t),roi,image_mean);
        [param,resnorm,exitflag,residual] = ...
            fit_2d_gaussian(crop);
        % translate local coord to global coord
        x = param(1);
        y = param(2);
        xyt(ii,3) = t;
        xyt(ii,1) = x0 + x-(1+CROP_RADIUS);
        xyt(ii,2) = y0 + y-(1+CROP_RADIUS);
        % xyt(ii,4) = param(3); % 20230704
    end

end
