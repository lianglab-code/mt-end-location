function [p,param] = localize_point(obj)
% point localization, a copy/modification of 
% image_viewer::op_localize_point.m
    
% This example localizes/adjusts the point around p0 in the image
% to the bright dot. The method used to localize a point is
% nonlinear fitting a Gaussian function.

% INPUT from obj:
% active_ind, cur_frame
% imgs, img_h, img_w

% OUTPUT:
% p: corrected point, 2x1 column vector
% param: [x;y;sigma;a;b;residual;exitflag]

% NOTE:
% Please refer to the program img_track_dot.m

    p = nan(2,1);
    param = nan(7,1);
    
    if obj.active_ind <= 0 || ...
            obj.active_ind > size(obj.imgroi.p,2)
        return;
    end

    % point initial guess
    p0 = obj.imgroi.p(:,obj.active_ind,obj.cur_frame);
    if sum(isnan(p0))>0
        return;
    end
    p0 = reshape(p0,[2 1]);
    p = p0;

    %% hard-coded criteria for dots
    MAX_TRY = ImageViewer.POINT_MAX_TRY;
    RMIN = ImageViewer.POINT_RMIN;
    RMAX = ImageViewer.POINT_RMAX;
    R = ImageViewer.POINT_R;

    %% algo begins here
    % fitting setup
    [xg, yg] = meshgrid(1:(2*R+1), 1:(2*R+1));
    xdata = cat(3, xg, yg);

    for ii = 1:MAX_TRY
        I = round(p(2));
        J = round(p(1));
        if I<(R+1) || I>(obj.img_h-R) ...
                || J<(R+1) || J>(obj.img_w-R)
            warning('the point is too close to the border, abort');
            return;
        end
        crop = obj.imgs((I-R):(I+R),(J-R):(J+R),obj.cur_frame);
        crop2 = sort(crop(:),'ascend');
        % guess of the gaussian model
        x0 = 1+R;
        y0 = 1+R;
        b0 = sum(crop2(1:5))/5;
        a0 = (crop2(end)+crop2(end-1))/2-b0;
        s0 = (RMIN+RMAX)/2;

        param_in = [x0; y0; s0; a0; b0];
        param_lb = [x0-R/2; y0-R/2; RMIN; crop2(end)/2; crop2(1)];
        param_ub = [x0+R/2; y0+R/2; RMAX; crop2(end); crop2(R*2*R)];

        param = helper_fitmodel(xdata,crop,...
                                param_in,...
                                param_lb,...
                                param_ub);
        x0 = param(1);
        y0 = param(2);
        param(1) = param(1)-(1+R)+J;
        param(2) = param(2)-(1+R)+I;
        p(1) = param(1);
        p(2) = param(2);
        % simple goodness-of-fit test: is the point at the center?
        if (abs(x0-R-1)<2) && (abs(y0-R-1)<2)
            break;
        end
    end

    %% -------------- NESTED FUNCTIONS -----------------

    function po = helper_fitmodel(xdata,Z,p0,pl,pu)
    %% HELPER_FITMODEL is a wrapper for the fit function.
    % po = helper_fitmodel(X,Y,xdata,p0,pl,pu)

    % INPUT:
    % xdata: meshgrid
    % Z: Z
    % p0: param guess
    % pl: param lowerbound
    % pu: param upperbound

    % OUTPUT:
    % po: param output, including res and flag

    % fitting options
        OPTIONS = optimoptions('lsqcurvefit', ...
                               'Algorithm', 'trust-region-reflective', ...
                               'Display','off');

        [param_out, res, ~, exitflag, ~] = ...
            lsqcurvefit(@fitmodel, ...
                        p0, ...
                        xdata, ...
                        Z, ...
                        pl, ...
                        pu, ...
                        OPTIONS);
        po = [param_out;res;exitflag];
    end

    % gaussian
    function f = fitmodel(f_params,xdata)
        x = xdata(:,:,1);
        y = xdata(:,:,2);
        x0 = f_params(1);
        y0 = f_params(2);
        s = f_params(3); % sigma
        a = f_params(4); % amplitude
        b = f_params(5); % baseline
        f = b + a.*exp(-((x-x0).^2+(y-y0).^2)/(2*s^2));
    end

end
