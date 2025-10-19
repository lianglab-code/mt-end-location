function move_axes(h_ax, varargin)
%% MOVE_AXES moves the axes across the figure, e.g., panning

% INPUT:
% h_ax: axes handle

% DESC:
% 1. button down (external call)
% 2. get current pos
% 3. mouse motion
% 4. get post pos
% 5. move

% reference:
%  Francois Bouffard's draggable

% user_renderer = 'zbuffer'; % opengl

if ~isgraphics(h_ax,'axes')
    error('no axes, quitting...');
    return;
end

% h_fig = gcbf;
for ii = 1:3
    h_fig = get(h_ax,'Parent');
    if isgraphics(h_fig,'Figure')
        break;
    end
end

if ~isgraphics(h_fig,'Figure')
    error('h_ax has no figure parent');
    return;
end

xylimit = [-inf inf -inf inf];

if nargin>1
    arg = varargin{1};
    if ischar(arg) && strcmpi(arg,'off')
        % state restoration
        initial_pointer = getappdata(h_ax,'initial_pointer');
        set(h_fig,'Pointer',initial_pointer);
        set(h_fig,'WindowButtonDownFcn',... 
                  getappdata(h_ax,'initial_wbdfcn'));
        set(h_fig,'WindowButtonUpFcn',... 
                  getappdata(h_ax,'initial_wbufcn'));
        set(h_fig,'WindowButtonMotionFcn',... 
                  getappdata(h_ax,'initial_wbmfcn'));
        rmappdata(h_ax,'xylimit');
        rmappdata(h_ax,'initial_pointer');
        rmappdata(h_ax,'initial_wbdfcn');
        rmappdata(h_ax,'initial_wbufcn');
        rmappdata(h_ax,'initial_wbmfcn');
        initial_userdata = getappdata(h_ax,'initial_userdata');
        set(h_ax,'UserData',initial_userdata);
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
