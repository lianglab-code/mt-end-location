function [p,param] = op_localize_point(img,p0,varargin)
%% OP_LOCALIZE_POINT is an example of extending the functionality
% of the image_viewer.

% This example localizes/adjusts the point around p0 in the image
% to the bright dot. The method used to localize a point is
% nonlinear fitting a Gaussian function.

% INPUT:
% img: 2d image
% p0: point, vector with two element
% param0: param0 of the gaussian function;
%         [x;y;sigma;a;b;residual;exitflag];
%         not used now, might be used to indicate the average param

% OUTPUT:
% p: corrected point, 2x1 column vector
% param: [x;y;sigma;a;b;residual;exitflag]

% NOTE:
% Please refer to the program img_track_dot.m

    %% input check
    [img_h,img_w,num_frames] = size(img);
    if num_frames>1
        warning('only 2d image is supported, abort');
        return;
    end
    
    p = nan(2,1);
    param = nan(7,1);
    if prod(size(p0))~=2
        warning('please input a point with correct format, abort');
        return;
    end
    if sum(isnan(p0))>0
        warning('point with nan value');
        return;
    end
    p0 = reshape(p0,[2 1]);
    p = p0;

    %% hard-coded criteria for dots
    MAX_TRY = 2; % the p0 might not be close enough to the center
    RMIN = 1; % minimium number of pixels
    RMAX = 8; % maximum number of pixels
    R = RMAX+1; % radius of cropping region for fitting

    %% algo begins here
    % fitting setup
    [xg, yg] = meshgrid(1:(2*R+1), 1:(2*R+1));
    xdata = cat(3, xg, yg);

    for ii = 1:MAX_TRY
        I = round(p0(2));
        J = round(p0(1));
        if I<(R+1) || I>(img_h-R) ...
                || J<(R+1) || J>(img_w-R)
            warning('the point is too close to the border, abort');
            return;
        end
        crop = img((I-R):(I+R),(J-R):(J+R));
        crop2 = sort(crop(:),'ascend');
        % guess of the gaussian model
        x0 = 1+R;
        y0 = 1+R;
        b0 = sum(crop2(1:5))/5;
        a0 = (crop2(end)+crop2(end-1))/2-b0;
        s0 = (RMIN+RMAX)/2;
        
        % param_in = [x0, y0, s0, a0, b0];
        % param_lb = [x0-R/2, y0-R/2, RMIN, crop2(end)/2, crop2(1)];
        % param_ub = [x0+R/2, y0+R/2, RMAX, crop2(end),
        % crop2(R*2*R)];
        param_in = [x0; y0; s0; a0; b0];
        param_lb = [x0-R/2; y0-R/2; RMIN; crop2(end)/2; crop2(1)];
        param_ub = [x0+R/2; y0+R/2; RMAX; crop2(end); crop2(R*2*R)];

        param = helper_fitmodel(xdata,crop,...
                                param_in,...
                                param_lb,...
                                param_ub);
        param(1) = param(1)-(1+R)+J;
        param(2) = param(2)-(1+R)+I;
        p(1) = param(1);
        p(2) = param(2);
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
    function f = fitmodel(params,xdata)
        x = xdata(:,:,1);
        y = xdata(:,:,2);
        % params:
        x0 = params(1);
        y0 = params(2);
        s = params(3); % sigma
        a = params(4); % amplitude
        b = params(5); % baseline
        f = b + a.*exp(-((x-x0).^2+(y-y0).^2)/(2*s^2));
    end

end