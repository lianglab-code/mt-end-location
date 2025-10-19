function canvas_keyboard_callback(hObject, eventdata, handles)
%% CANVAS_KEYBOARD_CALLBACK is the response function to the
% keyboard event of the CANVAS figure.

% reference:
% https://cn.mathworks.com/help/matlab/ref/...
% matlab.ui.figure-properties.html#property_d119e286196
global TOOLBAR_INFO;
global CANVAS_INFO;
global IMG_INFO;

curr_frame = CANVAS_INFO.curr_frame;
nframe = IMG_INFO.nframe;
h_cs = CANVAS_INFO.cs_handle;
h_img = CANVAS_INFO.h_img;

switch lower(eventdata.Key)
  case 'add'
    % disp('+');
    zoom_figure(CANVAS_INFO.cs_handle, CANVAS_INFO.mag_factor);
  case 'subtract'
    % disp('-');
    zoom_figure(CANVAS_INFO.cs_handle, 1/CANVAS_INFO.mag_factor);
  case 'escape'
    % disp(eventdata.Key);
    TOOLBAR_INFO.curr_butt = 0;
    deact_all_pbutt();
  %   %  otherwise
end

end