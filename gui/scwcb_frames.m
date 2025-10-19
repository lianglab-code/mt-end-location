function scwcb_frames(h_obj, evt)
%% SCWCB_FRAMES is a scrollwheel callback to scroll through image
% frames. It is registered to a figure object, specifically, to the
% 'WindowScrollWheelFcn' property.

% INPUT:
% h_obj: the figure object caller
% evt: event
% imgs: extra parameter, the multi-frame images

% ASSUMPTION:
% h_obj should have
% appdata: imgs -> image data
%        : cur_frame -> current frame number
%        : h_img -> image imshow object
%        : scroll_step -> scroll_step

% NOTE:
% This could serve as an example for writing a callback function.
% 1. Sharing data between objects
%    https://www.mathworks.com/help/matlab/creating_guis/share-data-among-callbacks.html
% 2. 

% appdata
cur_frame = getappdata(h_obj,'cur_frame');
if isempty(cur_frame)
    warning('no cur_frame appdata, figure not scrollable');
    return;
end
imgs = getappdata(h_obj,'imgs');
if isempty(imgs)
    warning('no imgs appdata, figure not scrollable');
    return;
end
h_img = getappdata(h_obj,'h_img');
if isempty(h_img)
    warning('no h_img appdata, figure not scrollable');
    return;
end

scroll_step = getappdata(h_obj,'scroll_step');
if isempty(scroll_step)
    scroll_step = 1;
    return;
end

[img_h, img_w, num_frames] = size(imgs);
sc = evt.VerticalScrollCount; % scrollcount
post_frame = cur_frame + sc*scroll_step;

set(0, 'currentfigure', h_obj);
if post_frame>=1 && post_frame<=num_frames
    set(h_img,'CData',imgs(:,:,post_frame));
    set(h_obj,'Name', num2str(post_frame));
    setappdata(h_obj,'cur_frame',post_frame);
end
