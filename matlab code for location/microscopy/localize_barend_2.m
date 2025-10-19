function [param_out, res_out, exitflag_out, arrow0] = ...
    localize_barend_2(imgs, varargin)
%% LOCALIZE_BAREND_2 estimates the end of filaments by a single click
%
% Input:
% imgs: image series
% arrow0: initial arrow, pointing from mt end to mt growing direction
%         [xs,ys; xe,ye]. start -> end
% 
% Output:
% param_out: num_frames x 6
%            1. x0
%            2. y0
%            3. sigma
%            4. theta
%            5. amplitude
%            6. baseline
% res_out: residual
% exitflag_out: exit flag
% arrow0: initial arrow, pointing from mt end to mt growing direction
%         [xs,ys; xe,ye]. start -> end
%
% Note:
% theta:
%
%            \
%             \
%     theta    \      
%  --------------.--------------> x
%                |
%                |
%                |
%                |
%                |
%                |
%                |
%                |
%                |
%
%                y
%
%
%
% Usage:
% 1. click the MT end on the first frame

    %% options
    options = struct;
    options.crop_radius = 6; % crop radius, used in fitting ---rring=6
    options.theta = pi/6;    % theta bound
    options.sigma = 2.0;     % sigma
    options.sigma_lb = 1.2;  % sigma lower bound
    options.sigma_ub = 2.5;  % sigma upper bound

    %% initialization
    [img_h,img_w,num_frames] = size(imgs);
    param_out = nan(num_frames, 6);
    res = nan(num_frames, 1);
    exitflag = nan(num_frames, 1);
    arrow0 = nan(2,2);

    %% first frame
    if nargin == 1
        tmpf = figure; % pick the MT end
        imshow(imgs(:,:,1),[]);
        [x0, y0] = getline(tmpf);
        display('arrow selected')
        arrow0 = [x0(1), y0(1); x0(2), y0(2)];
        close(tmpf);
    else
        arrow0 = varargin{1};
    end

    % [x0,y0]
    x0 = round(arrow0(1,1));
    y0 = round(arrow0(1,2));
    % croppd image
    x1 = x0 - options.crop_radius;
    x2 = x0 + options.crop_radius;
    y1 = y0 - options.crop_radius;
    y2 = y0 + options.crop_radius;
    cropped = image_crop(imgs(:,:,1),[x1,x2,y1,y2]);
    % theta0
    theta0 = angle((arrow0(2,1)+sqrt(-1)*arrow0(2,2)) - ...
                   (arrow0(1,1)+sqrt(-1)*arrow0(1,2)));
    % b0 and A0
    b0 = median(cropped(:));
    b0_lb = min(cropped(:));
    b0_ub = b0 + (b0 - b0_lb);
    A0 = max(cropped(:)) - b0;
    A0_lb = A0/2;
    A0_ub = A0;
    % param preparation
    param_in = [options.crop_radius,...
                options.crop_radius,...
                options.sigma,...
                theta0,...
                A0,...
                b0];
    param_lb = [1,...
                1,...
                options.sigma_lb,...
                theta0 - options.theta,...
                A0_lb,...
                b0_lb];
    param_ub = [1 + 2*options.crop_radius,...
                1 + 2*options.crop_radius,...
                options.sigma_ub,...
                theta0 + options.theta,...
                A0_ub,...
                b0_ub];
    % fitting
    [param, res, exitflag] = fit_mt_end_internal(cropped,...
                                                 param_in,...
                                                 param_lb,...
                                                 param_ub);
    % post-processing
    if isnan(res)
        error('cannot fit the first frame!')
    end
    param(1) = x0 + param(1) - (1 + options.crop_radius);
    param(2) = y0 + param(2) - (1 + options.crop_radius);
    param_out(1,:) = param;
    res_out(1) = res;
    exitflag_out(1) = exitflag;

    %% iterate
    for ii = 2:num_frames
        % coarse param from previous frames
        param_in = find_last_param(param_out, ii);
        if any(isnan(param))
            error(['cannot fit frame: ' num2str(ii)])
        end
        % [x0,y0]
        x0 = round(param_in(1));
        y0 = round(param_in(2));
        % croppd image
        x1 = x0 - options.crop_radius;
        x2 = x0 + options.crop_radius;
        y1 = y0 - options.crop_radius;
        y2 = y0 + options.crop_radius;
        cropped = image_crop(imgs(:,:,ii),[x1,x2,y1,y2]);
        % theta0
        theta0 = param_in(4);
        % b0 and A0
        b0 = median(cropped(:));
        b0_lb = min(cropped(:));
        b0_ub = b0 + (b0 - b0_lb);
        if b0_lb == b0_ub
            b0_lb = b0_lb - 1;
            b0_ub = b0_ub + 1;
        end
        A0 = max(cropped(:)) - b0;
        A0_lb = A0/2;
        A0_ub = A0;
        % param preparation
        param_in = [options.crop_radius,...
                    options.crop_radius,...
                    options.sigma,...
                    theta0,...
                    A0,...
                    b0];
        param_lb = [1,...
                    1,...
                    options.sigma_lb,...
                    theta0 - options.theta,...
                    A0_lb,...
                    b0_lb];
        param_ub = [1 + 2*options.crop_radius,...
                    1 + 2*options.crop_radius,...
                    options.sigma_ub,...
                    theta0 + options.theta,...
                    A0_ub,...
                    b0_ub];
        % fitting
        [param, res, exitflag] = fit_mt_end_internal(cropped,...
                                                     param_in,...
                                                     param_lb,...
                                                     param_ub);
        % post-processing
        param(1) = x0 + param(1) - (1 + options.crop_radius);
        param(2) = y0 + param(2) - (1 + options.crop_radius);
        param_out(ii,:) = param;
        res_out(ii) = res;
        exitflag_out(ii) = exitflag;
    end

    %% internal functions
    function param_internal = find_last_param(param0, param_ind)
        param_internal = nan(1,6);
        for ii_internal = (param_ind-1):(-1):1
            if all(~isnan(param0(ii_internal,:)))
                param_internal = param0(ii_internal,:);
                return;
            end
        end
    end
    
end

