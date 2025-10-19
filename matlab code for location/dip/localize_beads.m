function [x,y,r,I,rms] = localize_beads(img,x,y,r)
%% LOCALIZE_BEADS localizes the fluorescent beads
% The results of the localization can be used to 
% correct the chromatic aberration.
%
% Input:
% img: fluorescence image, black background
% x,y,r: coarse coord and radius, from detect_blob
%
% Output:
% x,y: centers of the beads
% r: radius
% I: intensity
% rms: root mean squares of residual
%
% See Also:
% detect_blob, fit_2d_gaussian, distance_cluster
% Default Params:

    [img_h,img_w] = size(img);

    % gaussian estimation
    np = numel(x);
    np = numel(x);
    gp = nan(5,np); % gaussian parameters, x,y,r,H,b
    res = nan(1,np); % resnorm
    rms = nan(1,np); % root mean squares
    for ii = 1:np
        x0 = round(x(ii));
        y0 = round(y(ii));
        r0 = round(r(ii));
        I1 = y0 - 3*r0;
        I2 = y0 + 3*r0;
        J1 = x0 - 3*r0;
        J2 = x0 + 3*r0;
        if I1 < 1 || I2 > img_h || J1 < 1 || J2 > img_w
            continue;
        end
        crop = img(I1:I2,J1:J2);
        % [param1,resnorm,exitflag,residual] = ...
        % fit_2d_gaussian(crop);
        % [param,res] = fit_2d_gaussian(crop);
        [gp(:,ii),res(ii)] = fit_2d_gaussian(crop);
        rms(ii) = sqrt(res(ii)/((6*r0+1)*(6*r0+1)));
        gp(1,ii) = x0 + (gp(1,ii)-(1+3*r0));
        gp(2,ii) = y0 + (gp(2,ii)-(1+3*r0));
    end

    x = gp(1,:)';
    y = gp(2,:)';
    r = gp(3,:)';
    I = gp(4,:)'+gp(5,:)';
    % figure;
    % imshow(img,[quantile(img(:),0.1),quantile(img(:),0.98)]);
    % hold on;
    % viscircles([x,y],r,'color','g');
    % viscircles([x1,y1],r1,'color','r');
    % hold off;

end
