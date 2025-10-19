function pbutt_1_callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reference
% https://cn.mathworks.com/help/matlab/ref/pan.html
% https://cn.mathworks.com/help/matlab/creating_guis/...
% add-code-for-components-in-callbacks.html

global TOOLBAR_INFO;
global CANVAS_INFO;
global IMG_INFO;

TOOLBAR_INFO.curr_butt = 1;
deact_all_pbutt();
this_pbutt = TOOLBAR_INFO.pbutts{TOOLBAR_INFO.curr_butt};
setappdata(this_pbutt,'is_on',1);

xylimit = [0.5 IMG_INFO.width+0.5 0.5 IMG_INFO.height+0.5];
move_axes(CANVAS_INFO.h_axes,xylimit);
end