function params = op_localize_all_endpoints(imgs,param0,varargin)
%% OP_LOCALIZE_ALL_ENDPOINTS tracks the dots in multi-frame imgs
% params = op_localize_all_points(imgs,param0)

% It tracks the dots in multi-frame images.
% The dots are initialized and specified by the parameter 
% param0.

% INPUT:
% imgs: multi-frame images, should have removed background;
% param0: the initial param, 8xnum_frames vector, 
%         cf. op_localize_endpoint. 
% first_frame: ignore frames before the first_frame
% showinfo_flag: display progress and parameter info

% OUTPUT:
% params: the parameter of dots in each frame;
%         dimension: 7 x np x num_frames

% NOTE:
% The behavior of this function is different from that of the
% op_localize_all_points, in the this function localizes endpoints
% from the current frame to the end, while op_localize_all_points
% localizes points from the first frame. This is because I suppose
% that it is more error prone to localize the endpoint; it should
% be helpful to incrementally achieve the localization aim.
    
% EXAMPLE:
% params = img_track_dot(imgs,param2);

    if numel(size(imgs))~=3
        error('please input a multiframe image');
        return;
    end

    [img_h, img_w, num_frames] = size(imgs);
    [dim,tmp] = size(param0);

    if dim~=8
        error('dimension of params is not 8');
        return;
    end

    if tmp~=num_frames
        error('length of params is not num_frames');
        return;
    end

    first_frame = 1;
    if nargin>2
        first_frame = varargin{1};
    end
    if first_frame<1 || first_frame>num_frames
        error('first_frame out of interval');
        return;
    end

    showinfo_flag = false;
    progress_interval = 0.1;
    if nargin>3
        showinfo_flag = varargin{2};
    end

    % params = nan(dim,num_frames);
    params = param0;

    %% hard-coded criteria for dots
    MAX_TRY = 4;
    % FWHM = 7; % the width of a MT
    FWHM = 4; % the width of a MT
    FWHM
    R = FWHM; % radius of cropping region for fitting
    if showinfo_flag
        showinfo();
    end

    %% algo begins here
    % fitting setup
    [xg, yg] = meshgrid(1:(2*R+1), 1:(2*R+1));
    xdata = cat(3, xg, yg);
    p0 = param0(:,first_frame);
    
    cur_progress = 0.1;
    for ii = first_frame:num_frames
        if showinfo_flag && ...
                ((ii-first_frame+1)/(num_frames-first_frame+1))...
                >cur_progress
            disp(['progress: ' num2str(cur_progress*100) '%']);
            cur_progress = cur_progress + progress_interval;
        end
        
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
            if I<(R+1) || I>(img_h-R) ...
                    || J<(R+1) || J>(img_w-R)
                warning(['point too close to border']);
                break;
            end
            % crop = img((I-R):(I+R),(J-R):(J+R)); to delete
            crop = imgs((I-R):(I+R),(J-R):(J+R),ii);
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
    function [x,y] = predict_next_center(params,ind)
    % predict center at frame ind+1
    % prediction based on linear motion model
    % param is 8x1 column vector
    % ind is the frame no. at which the center to be predicted
    % TODO: I should have built a bettern predictor:), but I have
    % no time. Kalman/Particle filters should be fine.
        [dim,num_frames] = size(params);
        x = nan;
        y = nan;
        if ind<1 || ind>num_frames || num_frames==1
            % no enough information
            return;
        end
        % only previous center available, no motion info
        x = params(1,ind);
        y = params(2,ind);
        % motion info available, besides previous center
        if ind>1 && ~isnan(x) && ~isnan(y) ...
                && ~isnan(params(1,ind-1)) ...
                && ~isnan(params(2,ind-1))
            dx = params(1,ind) - params(1,ind-1);
            dy = params(2,ind) - params(2,ind-1);
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
    % EXAMPLE:
    % params = [0 0 3 pi/4 10 0];
    % [X,Y] = meshgrid(-20:20,-20:20);
    % xdata = cat(3,X,Y);
    % f = fitmodel(params,xdata);
    % mesh(X,Y,f)
    % xlabel('X');
    % ylabel('Y');
    % text(4,60,texlabel('x=y=b=0;s=3;theta=pi/4;a=10'));
    % NOTE: the direction is from inside MT to the tip of MT. 
    %       For example, if theta=0, the growth direction of MT is from
    %       left to right.
    function f = fitmodel(params,xdata)
    % function I = FilamentTip2D(params, xdata)
        x = xdata(:,:,1);
        y = xdata(:,:,2);
        % params:
        x0 = params(1);
        y0 = params(2);
        s = params(3); % sigma
        t = params(4); % theta
        a = params(5); % amplitude
        b = params(6); % baseline
        
        g = -(x-x0).*sin(t-pi/2) + (y-y0).*cos(t-pi/2) + 0.5;
        g( g < 0 ) = 0;
        g( g > 1 ) = 1;
        A = 1/(2*s^2); % tmp var
        f = a*( g .*exp( -A*( ( x-x0 ).^2 + ( y-y0 ).^2 ) ) + ...
                (1-g).*exp( -A*(-( x-x0 )*sin(t) + ( y-y0 )*cos(t)).^2) ) + ...
            b;
    end
    
    function showinfo()
        disp(['func: ' mfilename]);
        disp(['MAX_TRY: ',num2str(MAX_TRY)]);
        disp(['FWHM: ',num2str(FWHM)]);
        disp(['R: ',num2str(R)]);
    end
end
