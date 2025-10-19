function move_line(h_line, x0, y0, varargin)
%% MOVE_LINE moves the line obj across the axes

%% NOT FINISHED

% INPUT:
% h_line: line handle

% DESC:
% 1. button down around the line (controlled in the caller)
% 3. mouse motion
% 4. get post pos
% 5. move
% 6. button up, the whole process is complete, all thing returned
%    to previous status, except the line XData and YData

% reference:
%  Francois Bouffard's draggable

% user_renderer = 'zbuffer'; % opengl

if ~isgraphics(h_line,'Line')
    error('no line, quitting..');
    return;
end

% h_ax = gcba
for ii = 1:2
    h_ax = get(h_line,'Parent');
    if isgraphics(h_ax,'Axes')
        break;
    end
end
if ~isgraphics(h_ax,'Axes')
    error('can not find axes obj, quitting...');
    return;
end

% h_fig = gcbf;
for ii = 1:2
    h_fig = get(h_ax,'Parent');
    if isgraphics(h_fig,'Figure')
        break;
    end
end
if ~isgraphics(h_fig,'Figure')
    error('can not find figure obj, quitting...');
    return;
end

if nargin>1
    arg = varargin{1};
    if ischar(arg) && strcmpi(arg,'off')
        % state restoration
        set(h_fig,'WindowButtonDownFcn',... 
                  getappdata(h_ax,'initial_wbdfcn'));
        set(h_fig,'WindowButtonUpFcn',... 
                  getappdata(h_ax,'initial_wbufcn'));
        set(h_fig,'WindowButtonMotionFcn',... 
                  getappdata(h_ax,'initial_wbmfcn'));
        rmappdata(h_line,'initial_wbdfcn');
        rmappdata(h_line,'initial_wbufcn');
        rmappdata(h_line,'initial_wbmfcn');
        initial_userdata = getappdata(h_line,'initial_userdata');
        set(h_line,'UserData',initial_userdata);
        rmappdata(h_ax,'initial_userdata');
        return;
    elseif  isnumeric(arg) && numel(arg)==4
        xylimit = arg; % TODO: bound check
    end
end


%% get the initial state and parameters
setappdata(h_ax,'initial_userdata', get(h_ax,'Userdata'));
setappdata(h_ax,'initial_wbdfcn',get(h_fig,'WindowButtonDownFcn'));
setappdata(h_ax,'initial_wbufcn',get(h_fig,'WindowButtonUpFcn'));
setappdata(h_ax,'initial_wbmfcn',get(h_fig, ...
                                     'WindowButtonMotionFcn'));
setappdata(h_ax,'initial_pointer',get(h_fig,'Pointer'));
setappdata(h_ax,'xylimit',xylimit);

%% interaction entry: click a button on the axes
% set(h_ax,'ButtonDownFcn',@click_axes);
set(h_fig,'WindowButtonDownFcn',{@wbdfcn,h_ax});
set(h_fig,'WindowButtonUpFcn',@wbufcn);
set(h_fig,'WindowButtonMotionFcn','');
set(h_fig,'Pointer','hand');

function wbdfcn(obj,evt,h_ax)
setappdata(h_ax,'initial_point',get(h_ax,'CurrentPoint'));
setappdata(h_ax,'initial_xlim',get(h_ax,'XLim'));
setappdata(h_ax,'initial_ylim',get(h_ax,'YLim'));
set(obj,'WindowButtonMotionFcn',{@movefcn,h_ax});

function wbufcn(obj,evt)
set(obj,'WindowButtonMotionFcn','');

%% movefcn start
function movefcn(obj,evt,h_ax)
point0 = getappdata(h_ax,'initial_point');
point1 = get(h_ax,'CurrentPoint');
dxy = point1(1,1:2) - point0(1,1:2);
xlim0 = getappdata(h_ax,'initial_xlim');
ylim0 = getappdata(h_ax,'initial_ylim');
xlim1 = xlim0 - dxy(1);
ylim1 = ylim0 - dxy(2);
xylimit = getappdata(h_ax,'xylimit');
if xlim1(1)>xylimit(1) && ...
        xlim1(2)<xylimit(2) && ...
        ylim1(1)>xylimit(3) && ...
        ylim1(2)<xylimit(4)
    set(h_ax,'XLim',xlim1);
    set(h_ax,'YLim',ylim1);
    drawnow();
    setappdata(h_ax,'initial_point',get(h_ax,'CurrentPoint'));
    setappdata(h_ax,'initial_xlim',get(h_ax,'XLim'));
    setappdata(h_ax,'initial_ylim',get(h_ax,'YLim'));
end
% movefcn end
