function pbutt_2_callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reference
% https://cn.mathworks.com/help/matlab/creating_guis/...
% add-code-for-components-in-callbacks.html

global TOOLBAR_INFO;
global CANVAS_INFO;
global IMG_INFO;

TOOLBAR_INFO.curr_butt = 2;
% deact_other_pbutt();
deact_all_pbutt();
this_pbutt = TOOLBAR_INFO.pbutts{TOOLBAR_INFO.curr_butt};
setappdata(this_pbutt,'is_on',1);

h_cs = CANVAS_INFO.cs_handle;
CANVAS_INFO.width = IMG_INFO.width;
CANVAS_INFO.height = IMG_INFO.height;
set(h_cs,'Resize','on');
set(h_cs,'Position',[10 10 CANVAS_INFO.width CANVAS_INFO.height]);
set(h_cs,'Resize','off');

% it is the axes that control the canvas shown in a figure
h_axes = CANVAS_INFO.h_axes;
set(h_axes,'XLim',[0.5 IMG_INFO.width+0.5]);
set(h_axes,'YLim',[0.5 IMG_INFO.height+0.5]);

end
