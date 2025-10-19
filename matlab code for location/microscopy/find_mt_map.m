function [param_mt, param_map, rel_pos, res_mt, exitflag_mt, arrow_mt] = find_mt_map(mtimg, mapimg, varargin)
%% FIND_MT_MAP finds the positions of MT ends and MAP, and the
% relative positions of MAP to MT end
%
% Input:
% mtimg: MT images
% mapimg: MAP images
% arrow_mt: 2 x 2 mat, first row: mt end, second row: mt growing direction
%
% Output:
% param_mt: num_frame x 6, [x,y,sigma,theta,amp,baseline]
% param_map: num_frame x 2, [x,y]
% rel_pos: num_frame x 2, [rel_x, rel_y]
%
% Note:
% 1. theta == 0 means the MT is growing leftward, i.e., the negative x-axis
%
%
%                \
%                 \
%    theta = pi/6  \
%  ---------------- .----------------------> x
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |
%                   |    
%                   y
%
% 2. res_pos is in the above coordinate system
% 3. x_res_pos > 0 means MAP is inside the MT;
%    while x_res_pos < 0 means MAP is outside of the MT, i.e., growing end
%

    num_frames = size(mtimg,3);

    param_mt = nan(num_frames, 6);
    param_map = nan(num_frames, 2);
    rel_pos = nan(num_frames, 2);

    if nargin>2
        arrow_mt = varargin{1};
        [param_mt, res_mt, exitflag_mt, arrow_mt] = localize_barend_2(mtimg, arrow_mt);
    else
        [param_mt, res_mt, exitflag_mt, arrow_mt] = localize_barend_2(mtimg);
    end
    xyt_mt = [param_mt(:,1:2),(1:num_frames)'];
    xyt_map = localize_spot(mapimg, xyt_mt);
    param_map = xyt_map(:,1:2);

    for ii = 1:num_frames
        if any(isnan( [param_mt(ii,:),param_map(ii,:)] ))
            continue;
        end
        xy_mt = param_mt(ii,1:2);
        theta = param_mt(ii,4) + pi;
        xy_map = param_map(ii,:);
        rel = xy_map - xy_mt;
        M = [cos(theta),sin(theta);...
             -sin(theta), cos(theta)];
        rel_pos(ii,:) = ( M*(rel') )';
    end
end
