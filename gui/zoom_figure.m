function zoom_figure(h_fig, mag)
%% ZOOM_FIGURE zooms the figure

% INPUT:
% h_fig: figure handle
% mag: magnifying factor, >1 zoom-in; <1 zoom-out;

% reference:
% https://cn.mathworks.com/help/matlab/ref/isgraphics.html
% https://cn.mathworks.com/help/matlab/ref/findall.html
% findall returns a handle array, not a cell!

% nothing to do
if mag==1
    return;
end

if mag>20 || mag<0.05
    warning('magnification factor is too extreme!');
end

% not a figure
if isgraphics(h_fig,'figure')~=1
    error('zoom_figure can only zoom a figure');
    return;
end

% don't bother to deal with the case in which the unit of axes is
% not normal
axes_handles = findall(h_fig,'type','axes');
num_axes = numel(axes_handles);
for ii = 1:num_axes
    axes_unit = get(axes_handles(ii),'unit');
    if strcmpi('normalized',axes_unit)~=1
        warning('done nothing for figure with unnormalized axes');
        return;
    end
end

% CONSTANTS
% MIN_WIDTH = 64;
% MIN_HEIGHT = 64;
MIN_WIDTH = 24;
MIN_HEIGHT = 24;
screen_pos = get(0,'ScreenSize');
MAX_WIDTH = screen_pos(3);
MAX_HEIGHT = screen_pos(4);

curr_pos = get(h_fig,'Position');
post_pos = uint16(curr_pos * mag);

if (post_pos(3) >= MIN_WIDTH && ...
    post_pos(4) >= MIN_HEIGHT && ...
    post_pos(3) < MAX_WIDTH && ...
    post_pos(4) < MAX_HEIGHT)
    curr_cen_x = curr_pos(1) + uint16(curr_pos(3)/2);
    curr_cen_y = curr_pos(2) + uint16(curr_pos(4)/2);
    post_min_x = curr_cen_x - uint16(post_pos(3)/2);
    post_min_y = curr_cen_y - uint16(post_pos(4)/2);
    post_max_x = curr_cen_x + uint16(post_pos(3)/2);
    post_max_y = curr_cen_y + uint16(post_pos(4)/2);
    if post_max_x >= MAX_WIDTH
        post_min_x = MAX_WIDTH - post_pos(3);
    end
    if post_max_y >= MAX_HEIGHT
        post_min_y = MAX_HEIGHT - post_pos(4);
    end
    post_pos(1) = post_min_x;
    post_pos(2) = post_min_y;
    set(h_fig, 'Position', post_pos);
end

end