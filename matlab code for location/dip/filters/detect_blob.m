function [x,y,r,I] = detect_blob(img,varargin)
%% DETECT_BLOG localizes the bright blobs
% The results of the localization can be used to 
% correct the chromatic aberration.
%
% Input:
% img: fluorescence image, black background
% 
% Optional Input:
% BG_RADIUS = 10; radius of rolling ball
% LEVEL = 8; % multi-scale filtering levels
% R0 = 0.5; % initial radius
% LIN_LOG = 'lin'; % linear steps
% STEP = 1; % step between linear scales
% STEP = sqrt(2); % step between log scales
% COUNT = 20; % the count of strongest points
% FACTOR = 3; % the std level
%
% Output:
% x,y: centers of the beads
% r: radius
% I: LoG response at [x,y]
%
% Example:
% est_num_np = 10000;
% thres = 1 - est_num_np/prod(size(img));
% [x2,y2,r2,I2] = detect_blob(img,'step',0.5,'count',100);
%
% Note:
% It works just like Frangi filter
% 
% Performance:
% for double image 1024x1024, it takes 0.6 seconds
%
% See Also:
% localize_beads
% 
% Default Params:
    BG_RADIUS = 10; % radius of rolling ball
    LEVEL = 8; % multi-scale filtering levels
    R0 = 0.5; % initial radius
    LIN_LOG = 'lin'; % linear steps
    STEP = 1; % step between linear scales
    % STEP = sqrt(2); % step between log scales
    COUNT = 20; % count of strongest point
    FACTOR = 3; % mean + std*factor

    if nargin > 1
        ii = 1;
        while ii <= numel(varargin)
            arg1 = varargin{ii};
            if ~ischar(arg1)
                error('unknown arg');
                return;
            end
            if strcmp(upper(arg1),'BG_RADIUS')
                BG_RADIUS = varargin{ii+1};
                ii = ii + 2;
            elseif strcmp(upper(arg1),'LEVEL')
                LEVEL = varargin{ii+1};
                ii = ii + 2;
            elseif strcmp(upper(arg1),'R0')
                R0 = varargin{ii+1};
                ii = ii + 2;
            elseif strcmp(upper(arg1),'LIN')
                LIN_LOG = 'lin';
                ii = ii + 1;
            elseif strcmp(upper(arg1),'LOG')
                LIN_LOG = 'log';
                if STEP < 1
                    warning('log step should be > 1');
                end
                ii = ii + 1;
            elseif strcmp(upper(arg1),'STEP')
                STEP = varargin{ii+1};
                if strcmp(LIN_LOG,'log') && STEP < 1
                    warning('log step should be > 1');
                end
                ii = ii + 2;
            elseif strcmp(upper(arg1),'COUNT')
                COUNT = varargin{ii+1};
                if COUNT < 1
                    warning('count of points should >= 1');
                    COUNT = 20;
                end
                ii = ii + 2;
            elseif strcmp(upper(arg1),'FACTOR')
                FACTOR = varargin{ii+1};
                ii = ii + 2;
            end
        end
    end

    if strcmp(LIN_LOG,'lin')
        % linear
        radius = (R0 + (0:(LEVEL-1)) .* STEP)';
    elseif strcmp(LIN_LOG,'log')
        % logarithmic
        radius = (R0 * STEP.^(0:(LEVEL-1)))';
    else
        error('weird');
        return;
    end

    [img_h,img_w] = size(img);
    % preprocessing
    img = bg_subtract(img,BG_RADIUS);
    img2 = filter_gauss_2d(img,1);
    img_bin = img2>(mean(img2(:))+FACTOR*std(img2(:)));
    img_bin = bwareaopen(img_bin,round(pi*R0^2));
    %
    img_log = zeros(img_h,img_w,LEVEL);
    for ii = 1:LEVEL
        r = radius(ii);
        knl = fspecial('log',round(12*r),r);
        img_log(:,:,ii) = imfilter(img,knl)*r^2;
    end
    [img_out,img_level] = max(-img_log,[],3);
    img_out = img_out .* img_bin;

    %
    % candidates - extreme2
    [candidates,candidates_int] = extrema2(img_out);
    if numel(candidates) > COUNT
        candidates = candidates(1:COUNT);
        candidates_int = candidates_int(1:COUNT);
    end
    [candidates_y, candidates_x] = ind2sub([img_h,img_w], ...
                                           candidates_int);
    candidates_level = img_level(candidates_int);
    candidates_r = radius(candidates_level);
    %
    x = candidates_x;
    y = candidates_y;
    r = candidates_r;
    I = candidates_int;

    % % NOTE: the general blob detector should not filter the output
    % % filtered candidates
    % targets_ind = (candidates_int>(median(candidates_int)));
    % targets_x = candidates_x(targets_ind);
    % targets_y = candidates_y(targets_ind);
    % targets_int = candidates_int(targets_ind);
    % targets_level = candidates_level(targets_ind);
    % targets_r = radius(targets_level);
    % % 
    % x = targets_x;
    % y = targets_y;
    % r = targets_r;
    % I = targets_int;

    % % debug
    % figure;
    % % imshow(img_level,[]);
    % imshow(img_out,[quantile(img_out(:),0.1),quantile(img_out(:),0.99)]);
    % hold on;
    % % plot(x,y,'g+','markersize',10);
    % viscircles([candidates_x,candidates_y],...
    %            candidates_r,'color','r');
    % % viscircles([targets_x,targets_y],...
    % %            targets_r,'color','g');
    % hold off;
    % figure;imshow(img_out~=0);

end
