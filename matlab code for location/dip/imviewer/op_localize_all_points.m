function params = op_localize_all_points(imgs,param0,varargin)
%% OP_LOCALIZE_ALL_POINTS tracks the dots in multi-frame imgs
% params = op_localize_all_points(imgs,param0)

% It tracks the dots in multi-frame images.
% The dots are initialized and specified by the parameter 
% param0.

% INPUT:
% imgs: multi-frame images, should have removed background;
% param0: the initial param, e.g, output of the img_select_dot.m
%       : for now, only the x and y coord are used;
% showinfo_flag: display progress and parameter info

% OUTPUT:
% params: the parameter of dots in each frame;
%         dimension: 7 x np x num_frames

% EXAMPLE:
% params = img_track_dot(imgs,param2);

% EXAMPLE COMPLETE:
% b = squeeze(imgs(:,:,3,:));
% imgs = bg_subtract(b,11);
% test_img = mean(imgs,3);
% ps = img_extract_dot(test_img);
% param = img_fit_dot(test_img,ps);
% param2 = img_select_dot(param);
% params = img_track_dot(imgs,param2);
% xy = params(1,:,:) + sqrt(-1)*params(2,:,:);
% xy = squeeze(xy);
% xy = xy.';
% play_gui_with_point(imgs,xy);
% % manual inspecting :(
% xy = xy(:,selected);

% EXAMPLE INSPECTION PART:
% ColorSet = varycolor(size(xy,2));
% legend_str = cell(1,size(xy,2));
% figure; hold on;
% for ii = 1:size(xy,2)
%     plot(real(xy(:,ii)), ...
%          imag(xy(:,ii)), ...
%          '.', ...
%          'color',ColorSet(ii,:));
%     posx = max(real(xy(:,ii)))+4;
%     posy = min(imag(xy(:,ii)))-4;
%     text(posx,posy,num2str(ii),...
%          'color',ColorSet(ii,:),...
%          'fontsize',12);
%     legend_str{ii} = num2str(ii);
% end
% axis ij;
% axis equal;
% axis([0 size(imgs,2) 0 size(imgs,1)]);
% legend(legend_str,'location','eastoutside');

if numel(size(imgs))~=3
    error('please input a multiframe image');
    return;
end

[img_h, img_w, num_frames] = size(imgs);
[dim,np] = size(param0);

if dim~=7
    error('something about the param is wrong');
    return;
end

showinfo_flag = false;
progress_interval = 0.1;
if nargin>2
    showinfo_flag = varargin{1};
end

params = nan(dim,np,num_frames);

%% hard-coded criteria for dots
MAX_TRY = 4;
RMIN = 1; % minimium number of pixels
RMAX = 8; % maximum number of pixels
R = RMAX+1; % radius of cropping region for fitting
if showinfo_flag
    showinfo();
end

%% algo begins here
% fitting setup
[xg, yg] = meshgrid(1:(2*R+1), 1:(2*R+1));
xdata = cat(3, xg, yg);
p0 = param0;

cur_progress = 0.1;
for ii = 1:num_frames
    % disp(num2str(ii));
    if showinfo_flag && (ii/num_frames)>cur_progress
        disp(['progress: ' num2str(cur_progress*100) '%']);
        cur_progress = cur_progress + progress_interval;
    end
    % img = imgs(:,:,ii); % to delete
    p = nan(size(p0));
    for jj = 1:np
        % if one point with nan center at a specific frame, the
        % localization procedure will not be carried out for that
        % point from that specific frame
        if sum(isnan(p0(:,jj)))>0 || ...
                sum(isinf(p0(:,jj)))>0
            continue;
        end
        for kk = 1:MAX_TRY
            I = round(p0(2,jj));
            J = round(p0(1,jj));
            if I<(R+1) || I>(img_h-R) ...
                    || J<(R+1) || J>(img_w-R)
                warning(['point ' num2str(jj) ...
                         ' too close to border']);
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
            s0 = (RMIN+RMAX)/2;
            
            param_in = [x0, y0, s0, a0, b0];
            param_lb = [x0-R/2, y0-R/2, RMIN, ...
                        crop2(end)/2, crop2(1)];
            param_ub = [x0+R/2, y0+R/2, RMAX, ...
                        crop2(end), crop2(R*2*R)];

            param_out = helper_fitmodel(xdata,crop,...
                                        param_in,...
                                        param_lb,...
                                        param_ub);
            x0 = param_out(1);
            y0 = param_out(2);
            param_out(1) = param_out(1)-(1+R)+J;
            param_out(2) = param_out(2)-(1+R)+I;
            p(:,jj) = param_out.';
            % simple goodness-of-fit test: is the point at the
            % center?
            if (abs(x0-R-1)<2) && (abs(y0-R-1)<2)
                break;
            else
                p0(1:2,jj) = p(1:2,jj);
            end
        end
    end
    p0 = p;
    params(:,:,ii) = p;
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

    function showinfo()
        disp(['func: ' mfilename]);
        disp(['MAX_TRY: ',num2str(MAX_TRY)]);
        disp(['RMIN: ',num2str(RMIN)]);
        disp(['RMAX: ',num2str(RMAX)]);
        disp(['R: ',num2str(R)]);
    end
    
end
