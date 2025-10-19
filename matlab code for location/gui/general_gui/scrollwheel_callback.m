function scrollwheel_callback(hObject, eventdata, handles)
%% SCROLLWHEEL_CALLBACK scrolls through image frames using mouse
% middle button

% reference:
% https://cn.mathworks.com/help/matlab/ref/...
% matlab.ui.figure-properties.html#property_d119e287293

global TOOLBAR_INFO;
global CANVAS_INFO;
global IMG_INFO;

curr_frame = CANVAS_INFO.curr_frame;
nframe = IMG_INFO.nframe;
h_cs = CANVAS_INFO.cs_handle;
h_img = CANVAS_INFO.h_img;

% scrollcount
sc = eventdata.VerticalScrollCount;

post_frame = curr_frame + sc;

set(0, 'currentfigure', h_cs);
if post_frame>=1 && post_frame<=nframe
    CANVAS_INFO.curr_frame = post_frame;
    set(h_img,'CData',IMG_INFO.img(:,:,post_frame));
    set(h_cs,'Name', ['Canvas:' num2str(post_frame)]);
end

end