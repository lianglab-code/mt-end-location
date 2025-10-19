classdef ImageViewer < handle
% viewer for multi-frame images

% external dependencies:
% 1. move_axes.m

    properties (Constant)
        % window constants
        SCREEN_POS = get(0,'ScreenSize');
        MAX_WIDTH = ImageViewer.SCREEN_POS(3);
        MAX_HEIGHT = ImageViewer.SCREEN_POS(4);
        % plotting constants
        PM = 'o'; % point marker
        RM = 'o'; % rect marker
        PC = 'r'; % point color
        RC = 'm'; % rect color
        AC = 'm'; % arrow color
        PS = 6; % point marker size
        RS = 6; % rect marker size
        ALW = 1; % arrow line width
        AHL = 12; % arrow head length
        ABL = 2.5*ImageViewer.AHL; % arrow body length, used to
                                   % adjust the Stop point
        PICK_R = 20; % radius of point select region
        MAG_FACTOR = 1.5;
        % extra constants, maybe to be deleted
        KYMO_N = 100; % kymograph, number of points along the line
        KYMO_W = 1; % kymograph, width of the line
        custom_pointer = ImageViewer.make_pointer(); % for arrow
                                                     % selection
        % hard-coded criteria for point model
        POINT_MAX_TRY = 4; % the p0 might not be close enough to
                           % the center
        POINT_RMIN = 1; % minimium number of pixels
        POINT_RMAX = 8; % maximum number of pixels
        POINT_R = ImageViewer.POINT_RMAX+1; % radius of cropping
                                            % region for fitting
        % hard-coded criteria for endpoint model
        ENDPOINT_MAX_TRY = 2; % the p0 might not be close enough to
                              % the center
        % FWHM = 7; % the width of a MT
        ENDPOINT_FWHM = 4; % the width of a MT
        ENDPOINT_R = ImageViewer.ENDPOINT_FWHM; % radius of
                                                % cropping region
                                                % for fitting
    end

    properties
        % debug
        showinfo_flag = false;
        % image info
        imgs = [];
        img_h = 0;
        img_w = 0;
        num_frames = 0;
        % indicators
        cur_frame = 0; % current frame
        cur_mode = 'general'; % 'general' 'roip' 'roir' 'move_axes' 
        active_ind = 0; % current roi, e.g, line
                        % internal data representation
        imgroi = struct;
        % gui handles
        h_fig;
        h_axes;
        h_img;
        % gui interaction
        % gui representation of imgroi
        lineroi = struct;
        % mouse 
        scroll_step = 1; % scroll step
    end
    
    methods
        % constructor
        function obj = ImageViewer(imgs,varargin)
            [img_h, img_w, num_frames] = size(imgs);
            cur_frame = 1;
            cur_mode = 'general';
            active_ind = 0;
            scroll_step = 1;
            if nargin>1
                imgroi = varargin{1};
                if ~isstruct(imgroi)
                    error('imgroi is not a struct');
                    return;
                end
                if ~isfield(imgroi,'p')
                    imgroi.p = zeros(2,0,num_frames);
                else
                    if ~isempty(imgroi.p)
                        if size(imgroi.p,1)~=2 || ...
                                size(imgroi.p,3)~=num_frames
                            error('wrong dimension: imgroi.p');
                            return;
                        end
                    end
                end
                if ~isfield(imgroi,'a')
                    imgroi.a = zeros(4,0,num_frames);
                else
                    if ~isempty(imgroi.a)
                        if size(imgroi.a,1)~=4 || ...
                                size(imgroi.a,3)~=num_frames
                            error('wrong dimension: imgroi.a');
                            return;
                        end
                    end
                end
                if ~isfield(imgroi,'a2')
                    imgroi.a2 = zeros(8,0,num_frames);
                else
                    if ~isempty(imgroi.a2)
                        if size(imgroi.a2,1)~=8 || ...
                                size(imgroi.a2,3)~=num_frames
                            error('wrong dimension: imgroi.a2');
                            return;
                        end
                    end
                end
                if ~isfield(imgroi,'r')
                    imgroi.r = zeros(4,0,num_frames);
                else
                    if ~isempty(imgroi.r)
                        if size(imgroi.r,1)~=4 || ...
                                size(imgroi.r,3)~=num_frames
                            error('wrong dimension: imgroi.r');
                            return;
                        end
                    end
                end
            else
                imgroi.p = zeros(2,0,num_frames);
                imgroi.a = zeros(4,0,num_frames);
                imgroi.a2 = zeros(8,0,num_frames);
                imgroi.r = zeros(4,0,num_frames);
            end
            % corresponding line struct
            lineroi = struct;
            lineroi.p = cell(1,0); % hold line obj
            lineroi.a = cell(1,0); % hold line obj
            lineroi.r = cell(1,0); % hold line obj

            % IMAGE FIGURE INIT
            h_fig = figure( ...
                'Name', num2str(cur_frame), ...
                'NumberTitle', 'off', ...
                'Visible','off', ...
                'Position',[int16(ImageViewer.MAX_WIDTH/2)-img_w ...
                            int16(ImageViewer.MAX_HEIGHT/2)-img_h ...
                            img_w ...
                            img_h], ...
                'Units', 'pixels', ...
                'Menubar','none', ...
                'Renderer','painter', ... 
                'Resize','off');

            % IMAGE DISPLAY INIT
            h_axes = axes( ...
                'Parent', h_fig, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Color', 'none', ...
                'TickDirMode','manual', ...
                'userdata', []);
            set(h_axes, 'xtick', [], 'ytick', []);
            tmpimg = reshape(imgs(:,:,1),[img_w*img_h,1]);
            tmplow = quantile(tmpimg,0.1);
            tmphigh = quantile(tmpimg,0.99);
            h_img = imshow(imgs(:,:,1), [tmplow tmphigh], ...
                           'Parent', h_axes, ...
                           'Border', 'tight');
            set(h_axes, 'XLimMode','manual',...
                        'YLimMode','manual',...
                        'ZLimMode','manual',...
                        'CLimMode','manual',...
                        'ALimMode','manual')
            axis(h_axes, 'manual');
            clear 'tmping' 'tmplow' 'tmphigh';

            % Display the main window
            % movegui(h_fig, 'southwest');
            set(h_fig, 'Visible', 'on');

            obj.imgs = imgs;
            obj.img_h = img_h;
            obj.img_w = img_w;
            obj.num_frames = num_frames;
            obj.cur_frame = cur_frame;
            obj.cur_mode = cur_mode;
            obj.active_ind = active_ind;
            obj.imgroi = imgroi;
            obj.h_fig = h_fig;
            obj.h_axes = h_axes;
            obj.h_img = h_img;
            obj.lineroi = lineroi;
            obj.scroll_step = scroll_step;
            
            % last, setup callbacks; if callbacks are setup before
            % assignment of the object properties, the properties
            % are set to default value.
            set(h_fig, ...
                'WindowButtonDownFcn', '', ...
                'WindowButtonMotionFcn', '', ...
                'WindowButtonUpfcn', '', ...
                'WindowScrollWheelFcn',@obj.scwcb, ...
                'WindowKeyPressFcn', @obj.kbcb);
            
            % plot lines
            %            update_points();
            %            update_arrows();
            %            update_rects();

        end
    end

    % callbacks functions, can be private too
    % callback method signature: 
    % https://www.mathworks.com/help/matlab/matlab_oop/...
    %         class-methods-for-graphics-callbacks.html
    methods(Access='private')
        % scroll wheel
        scwcb(obj,src,evt);
        % keyboard
        kbcb(obj,src,evt);
        % windows button, mouse
        wbdcb(obj,src,evt); % equiv wbdcb_line
        wbmcb(obj,src,evt,varargin);
        wbucb(obj,src,evt,varargin);
        % built-in operations
        kymo(obj); % op_kymograph
        [p,param] = localize_point(obj);
        params = localize_left_points(obj);
        [p,param] = localize_endpoint(obj);
        params = localize_left_endpoints(obj);
        localize_rect(obj);
        localize_left_rects(obj);
        % kb callback for built-in operations
        op_on_point(obj);
        op_on_left_points(obj);
        op_on_arrow(obj);
        op_on_left_arrows(obj);
        op_on_rect(obj);
        op_on_left_rects(obj);
    end

    % GUI functions internal
    methods(Access='private')
        update_points(obj);
        update_arrows(obj);
        update_rects(obj);
        delete_point(obj);
        delete_arrow(obj);
        delete_rect(obj);
        delete_all_points(obj);
        delete_all_arrows(obj);
        delete_all_rects(obj);
    end

    % GUI functions public
    methods
        mode_reset(obj);
        mode_move(obj,varargin);
        mode_roip(obj);
        mode_roia(obj);
        mode_roir(obj);
    end

    % output functions
    methods
        function export_var(obj)
            assignin('base','imgroi',obj.imgroi);
        end
    end

    % helper functions
    methods(Static,Access='private')
        P = make_pointer();
        [x,y,w,h] = rect_line2roi(rectx,recty);
    end

    % helper functions
    methods(Access='private')
        [d,ind] = calc_closest_point(obj,x,y);
        [d,ind,arrowend] = calc_closest_arrow(obj,x,y);
        ind = calc_bounding_rect(obj,x,y);
        add_point(obj,x,y);
        add_arrow(obj,x1,y1,x2,y2); % p1 points to p2
        add_rect(obj,x,y,w,h);
    end

end
