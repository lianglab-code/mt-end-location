function init_global_param(img)
%% INIT_GLOBAL_PARAM initializes the parameters necessary for other
%% programs.

%% GLOBAL PARAM LIST
global IMG_INFO;
global TOOLBAR_INFO;
global CANVAS_INFO;

%% IMG_INFO
IMG_INFO = struct();
IMG_INFO.img = img;
IMG_INFO.nchannel = 1;
IMG_INFO.nslice = 1;
[h,w,num] = size(img);
IMG_INFO.height = h;
IMG_INFO.width = w;
IMG_INFO.nframe = num;
IMG_INFO.is_init = 1;

%% TOOLBAR_INFO
% assuming the icon size is 16x16
TOOLBAR_INFO = struct();
TOOLBAR_INFO.is_init = 0; % init flag
TOOLBAR_INFO.tb_handle = 0; % fig handle
TOOLBAR_INFO.butt_size = 64;
TOOLBAR_INFO.margin_size = 8;
TOOLBAR_INFO.num_row = 5;
TOOLBAR_INFO.num_column = 2;
TOOLBAR_INFO.num_pbutt = TOOLBAR_INFO.num_row * ...
    TOOLBAR_INFO.num_column;
grid_size = (TOOLBAR_INFO.butt_size + 2*TOOLBAR_INFO.margin_size);
TOOLBAR_INFO.width = TOOLBAR_INFO.num_column * grid_size;
TOOLBAR_INFO.height = TOOLBAR_INFO.num_row * grid_size;
% pbutts are figure obj initialized in init_gui.m
TOOLBAR_INFO.pbutts = cell(1,TOOLBAR_INFO.num_pbutt);
TOOLBAR_INFO.pbutt_names = cell(1,TOOLBAR_INFO.num_pbutt);
TOOLBAR_INFO.cdata = cell(1,TOOLBAR_INFO.num_pbutt); % icon
TOOLBAR_INFO.pbutt_x = zeros(1,TOOLBAR_INFO.num_pbutt);
TOOLBAR_INFO.pbutt_y = zeros(1,TOOLBAR_INFO.num_pbutt);
TOOLBAR_INFO.curr_butt = 0; % the current active pbutt, deactivate
                            % other pbutt
TOOLBAR_INFO.pbutt_deact = cell(1,TOOLBAR_INFO.num_pbutt);
TOOLBAR_INFO.pbutt_callback = cell(1,TOOLBAR_INFO.num_pbutt);
for ii = 1:TOOLBAR_INFO.num_pbutt
    r = ceil(ii/TOOLBAR_INFO.num_column);
    c = mod(ii-1,TOOLBAR_INFO.num_column);
    x = grid_size*c + TOOLBAR_INFO.margin_size;
    y = grid_size*(r-1) + TOOLBAR_INFO.margin_size;
    y = TOOLBAR_INFO.height - y - TOOLBAR_INFO.butt_size;
    TOOLBAR_INFO.pbutt_x(ii) = x;
    TOOLBAR_INFO.pbutt_y(ii) = y;
    TOOLBAR_INFO.cdata{ii} = [];
end
% calculate pbutt info
dir_loc = mfilename('fullpath');
pos = strfind(dir_loc,filesep);
if isempty(pos)
    error('bad thing happens');
end
dir_loc = dir_loc(1:pos(end));
helper_add_pbutt(1, 'move', strcat(dir_loc,'icons/hand_64.png'), ...
                 @pbutt_1_callback, @pbutt_1_deact);
helper_add_pbutt(2, 'restore', strcat(dir_loc,'icons/restore_64.png'), ...
                 @pbutt_2_callback);
helper_add_pbutt(3, 'zoom in image', strcat(dir_loc,'icons/zoomin_64.png'), ...
                 @pbutt_3_callback);
helper_add_pbutt(4, 'zoom out image', strcat(dir_loc,'icons/zoomout_64.png'), ...
                 @pbutt_4_callback);
helper_add_pbutt(5, 'zoom in figure', strcat(dir_loc,'icons/zoomin_wborder_64.png'), ...
                 @pbutt_5_callback);
helper_add_pbutt(6, 'zoom out figure', strcat(dir_loc,'icons/zoomout_wborder_64.png'), ...
                 @pbutt_6_callback);
helper_add_pbutt(7, 'contrast', strcat(dir_loc,'icons/contrast_64.png'), ...
                 @pbutt_7_callback);
helper_add_pbutt(8, 'setting', strcat(dir_loc,'icons/setting_64.png'), ...
                 @pbutt_8_callback);

%% TOOLBAR EXTENTION BEGIN
% 1 DRAWING / ROI / POI
helper_add_pbutt(9, 'pick obj', strcat(dir_loc,'icons/picker_64.png'), ...
                 @pbutt_9_callback);

%% TOOLBAR EXTENTION END

%% CANVAS_INFO
CANVAS_INFO = struct();
CANVAS_INFO.is_init = 0; % init flag
CANVAS_INFO.cs_handle = 0; % fig handle
CANVAS_INFO.width = IMG_INFO.width;
CANVAS_INFO.height = IMG_INFO.height;
CANVAS_INFO.h_axes = 0;
CANVAS_INFO.h_img = 0;
CANVAS_INFO.curr_frame = 1;
CANVAS_INFO.mag_factor = 1.5;

end
