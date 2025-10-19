function [drifts,cum_drifts] = img_calc_drift(ps,varargin)
%% IMG_CALC_DRIFT calculates the drift between consecutive frames
% [drifts,cum_drifts] = img_calc_drift(ps)
% Step 05 for registration of MT static images: calculation of
% drifts

% INPUT:
% ps: centers, 2 * np * num_frames
% 'robust': optional, to use statistics to exclude outliers

% OUTPUT:
% drifts: 2 * num_frames-1; instantaneous drift
% cum_drifts: 2 * num_frames; cumulative drift relative to the
%             first frame

% NOTE:
% 

% EXAMPLE:
% % params is the output of the img_track_dot
% [drifts,cum_drifts] = img_calc_drift(params(1:2,:,:));

[dim,np,num_frames] = size(ps);
if dim~=2
    error('ps must be of the form of: 2 * np * num_frames');
    return;
end

drifts = zeros(2,num_frames-1);
cum_drifts = zeros(2,num_frames);

is_robust = false;
if nargin>1
    if strcmp(lower(varargin{1}),'robust')
        is_robust = true;
    end
end

for ii = 2:num_frames
    ps2 = ps(:,:,ii);
    ps1 = ps(:,:,ii-1);
    % remove nan values
    tmp = ps2-ps1;
    ds = sqrt(sum(tmp.^2,1));
    if is_robust % robust
        tmpmean = nanmean(ds);
        tmpstd = nanstd(ds);
        if tmpstd<eps % only one point
            flag = ~isnan(ds);
        else % more than one point
            flag = abs(ds-tmpmean)<tmpstd;
        end
    else % non-robust
        flag = ~isnan(ds);
    end
    drifts(:,ii-1) = mean(tmp(:,flag),2);
    cum_drifts(:,ii) = cum_drifts(:,ii-1)+...
        drifts(:,ii-1);
end
