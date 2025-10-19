function params = localize_left_endpoints(obj)
% endpoint localization for left frames, a copy/modification of
% image_viewer::op_localize_all_endpoints.m

% This example localizes/adjusts the endpoint around p0 in the image
% to tubule end, e.g., MT end. The method used to localize a point is
% nonlinear fitting a filament tip model.

% INPUT from obj:
% active_ind, cur_frame
% imgs, img_h, img_w, num_frames

% OUTPUT:
% param: [x;y;sigma;a;b;residual;exitflag]

% NOTE:
% Please refer to the program img_track_dot.m

    obj.op_on_arrow();
    param0 = squeeze(obj.imgroi.a2(:,obj.active_ind,:));
    params = param0;

    %% hard-coded criteria for dots
    MAX_TRY = ImageViewer.ENDPOINT_MAX_TRY; 
    FWHM = ImageViewer.ENDPOINT_FWHM; % the width of a MT
    R = ImageViewer.ENDPOINT_R; % radius of cropping region for fitting

    %% algo begins here
    % fitting setup
    [xg, yg] = meshgrid(1:(2*R+1), 1:(2*R+1));
    xdata = cat(3, xg, yg);
    p0 = param0(:,obj.cur_frame);

    for ii = obj.cur_frame:obj.num_frames      
        p = nan(size(p0));
        % if one point with nan center at a specific frame, the
        % localization procedure will not be carried out for that
        % point from that specific frame
        if sum(isnan(p0))>0 || sum(isinf(p0))>0
            disp(['last frame: ' num2str(ii)]);
            break;
        end

        if ii>2
            res_mean = nanmean(param0(...
                7,(ii-2):ii));
            res_std = nanstd(param0(...
                7,(ii-2):ii));
        else
            res_mean = param0(7,ii);
            res_std = inf;
        end
        if res_std==0 || isnan(res_std)
            res_std = inf;
        end

        for kk = 1:MAX_TRY
            I = round(p0(2));
            J = round(p0(1));
            if I<(R+1) || I>(obj.img_h-R) ...
                    || J<(R+1) || J>(obj.img_w-R)
                warning(['point too close to border']);
                break;
            end
            crop = obj.imgs((I-R):(I+R),(J-R):(J+R),ii);
            crop2 = sort(crop(:),'ascend');
            % guess of the gaussian model
            x0 = 1+R;
            y0 = 1+R;
            b0 = sum(crop2(1:5))/5;
            a0 = (crop2(end)+crop2(end-1))/2-b0;
            s0 = FWHM;
            t0 = p0(4);
            
            param_in = [x0, y0, s0, t0, a0, b0];
            param_lb = [x0-R/2, y0-R/2, FWHM/3, t0-pi/4, ...
                        crop2(end)/2, crop2(1)];
            param_ub = [x0+R/2, y0+R/2, FWHM*3, t0+pi/4, ...
                        crop2(end), crop2(R*2*R)];

            param_out = helper_fitmodel(xdata,crop,...
                                        param_in,...
                                        param_lb,...
                                        param_ub);
            x0 = param_out(1);
            y0 = param_out(2);
            param_out(1) = param_out(1)-(1+R)+J;
            param_out(2) = param_out(2)-(1+R)+I;
            p = param_out.';
            % simple goodness-of-fit test: is the point at the
            % center?
            if (abs(x0-R-1)<2) && (abs(y0-R-1)<2) ...
                    && abs(p(7)-res_mean)<res_std
                break;
            else
                p0 = p;
            end
        end
        p0 = p;
        params(:,ii) = p;
    end

    %% -------------- NESTED FUNCTIONS -----------------
    function [x,y] = predict_next_center(f_params,ind)
    % predict center at frame ind+1
    % prediction based on linear motion model
    % param is 8x1 column vector
    % ind is the frame no. at which the center to be predicted
    % TODO: I should have built a bettern predictor:), but I have
    % no time. Kalman/Particle filters should be fine.
        [dim,num_frames] = size(f_params);
        x = nan;
        y = nan;
        if ind<1 || ind>num_frames || num_frames==1
            % no enough information
            return;
        end
        % only previous center available, no motion info
        x = f_params(1,ind);
        y = f_params(2,ind);
        % motion info available, besides previous center
        if ind>1 && ~isnan(x) && ~isnan(y) ...
                && ~isnan(f_params(1,ind-1)) ...
                && ~isnan(f_params(2,ind-1))
            dx = f_params(1,ind) - f_params(1,ind-1);
            dy = f_params(2,ind) - f_params(2,ind-1);
            x = x + dx;
            y = y + dy;
        end
    end

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
        po = [param_out,res,exitflag];
    end

    % filament tip
    function f = fitmodel(f_params,xdata)
    % function I = FilamentTip2D(f_params, xdata)
        x = xdata(:,:,1);
        y = xdata(:,:,2);
        x0 = f_params(1);
        y0 = f_params(2);
        s = f_params(3); % sigma
        t = f_params(4); % theta
        a = f_params(5); % amplitude
        b = f_params(6); % baseline
        g = -(x-x0).*sin(t-pi/2) + (y-y0).*cos(t-pi/2) + 0.5;
        g( g < 0 ) = 0;
        g( g > 1 ) = 1;
        A = 1/(2*s^2); % tmp var
        f = a*( g .*exp( -A*( ( x-x0 ).^2 + ( y-y0 ).^2 ) ) + ...
                (1-g).*exp( -A*(-( x-x0 )*sin(t) + ( y-y0 )*cos(t)).^2) ) + ...
            b;
    end
end
