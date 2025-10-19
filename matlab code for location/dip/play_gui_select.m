function imgout = play_gui_select(img)
%% PLAY_GUI_SELECT play image and select rect rois
%  rois = play_gui_select(img)
%  Only rect roi is supported.

% INPUT:
% img: h*w or h*w*frames or h*w*channels*frames

%% INIT
    xyz = zeros(1,6);
    ind = 0;
    imgout = cell(1,0);
    numout = 0;

    sz_img = size(img);
    dim_img = numel(sz_img);
    img_height = sz_img(1);
    img_width = sz_img(2);
    num_channels = 1;
    num_frames = 1;

    if dim_img>2
        if dim_img==3
            num_frames = sz_img(3);
            img_display = img;
        else
            num_channels = sz_img(3);
            num_frames = sz_img(4);
            if num_channels==2
                img_display = zeros(img_height,img_width,3, ...
                                    num_frames);
                for i=1:num_frames
                    img_display(:,:,1,i) = ...
                        img(:,:,1,i)/max(max(img(:,:,1,i)));
                    img_display(:,:,2,i) = ...
                        img(:,:,2,i)/max(max(img(:,:,2,i)));
                end
            elseif num_channels==3
                img_display = zeros(sz_img);
                for i=1:num_frames
                    img_display(:,:,1,i) = ...
                        img(:,:,1,i)/max(max(img(:,:,1,i)));
                    img_display(:,:,2,i) = ...
                        img(:,:,2,i)/max(max(img(:,:,2,i)));
                    img_display(:,:,3,i) = ...
                        img(:,:,3,i)/max(max(img(:,:,3,i)));
                end
            else
                error('image has more than 3 channels');
                return;
            end
        end
    end
    

    %% UI


    % Create and then hide the GUI as it is being constructed.
    % [left bottom width height]
    h_main_fig = figure( ...
        'Name', num2str(1), ...
        'Visible','off', ...
        'Position',[1 1 900 700], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_main_fig, ...
        'windowbuttondownfcn', @wbdcb, ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '', ...
        'windowscrollwheelfcn',@scrollwheel_cb, ...
        'windowkeypressfcn', '');

    % Initialization
    % Construct the components.
    % 1. Axes
    h_img_axes = axes( ...
        'Parent', h_main_fig, ...
        'Units', 'pixels', ...
        'Position', [50 80 800 600], ...
        'userdata', []);
    set(h_img_axes, 'xtick', [], 'ytick', []); 
    if(num_channels==1)
        imshow(img_display(:,:,1),[],...
               'Parent', h_img_axes);
    else
        imshow(img_display(:,:,:,1),...
               'Parent', h_img_axes);
    end
    axis(h_img_axes, 'manual');

    % 2. Slider
    h_img_slider = uicontrol( ...
        'Parent', h_main_fig, ...
        'style','slider', ...
        'position',[50,30,800,20], ...
        'Max', num_frames, ...
        'Min', 1, ...
        'SliderStep',[2 2]./(num_frames-1), ...
        'Callback', @h_img_slider_Callback);
    set(h_img_slider, 'Value', 1);
    addlistener(h_img_slider, ...
                'ContinuousValueChange', ...
                @h_img_slider_Callback);

    % Display the main window
    set(h_main_fig, 'Name', num2str(get(h_img_slider,'value')));
    movegui(h_main_fig, 'center');
    set(h_main_fig, 'Visible', 'on');
    uiwait(h_main_fig);


    %% Callbacks

    function h_img_slider_Callback(src, evt)
        v = round(get(src, 'Value'));
        if(num_channels==1)
            imshow(img_display(:,:,v),[],...
                   'Parent', h_img_axes);
        else
            imshow(img_display(:,:,:,v),...
                   'Parent', h_img_axes);
        end
        drawnow;
        set(h_main_fig, 'Name', num2str(v));
    end
    
    function scrollwheel_cb(src, evt, handles)
        v = round(get(h_img_slider,'value'));
        sc = evt.VerticalScrollCount;
        v2 = v+sc;
        if v2>=1 && v2<=num_frames
            set(h_img_slider,'value',v2);
            if(num_channels==1)
                imshow(img_display(:,:,v2),[],...
                       'Parent', h_img_axes);
            else
                imshow(img_display(:,:,:,v2),...
                       'Parent', h_img_axes);
            end
            drawnow;
            set(h_main_fig, 'Name', num2str(v2));
        end
    end
    
    function wbdcb(src, evt, handles)
        xy = round(get(h_img_axes,'currentpoint'));
        v = round(get(h_img_slider,'value'));
        ind = mod(ind+1,2);
        if(ind==1)
            % first click
            xyz(1) = xy(1,1);
            xyz(2) = xy(1,2);
            xyz(3) = v;
        else
            numout = numout + 1;
            % second click
            xyz(4) = xy(1,1);
            xyz(5) = xy(1,2);
            xyz(6) = v;
            for(ii = 1:3)
                if(xyz(ii) > xyz(ii+3))
                    tmp = xyz(ii);
                    xyz(ii) = xyz(ii+3);
                    xyz(ii+3) = tmp;
                end
            end
            if(num_channels==1)
                imgout{numout} = img(...
                    xyz(2):xyz(5),...
                    xyz(1):xyz(4),...
                    xyz(3):xyz(6));
                str = sprintf( ...
                    'I:%d:%d\nJ:%d:%d\nt:%d:%d', ...
                    xyz(2),xyz(5),xyz(1),xyz(4),xyz(3),xyz(6));
                disp(sprintf('crop#: %d',numout));
                disp(str);
            else
                imgout{numout} = img(...
                    xyz(2):xyz(5),...
                    xyz(1):xyz(4),...
                    :,...
                    xyz(3):xyz(6));
                str = sprintf( ...
                    'I:%d:%d\nJ:%d:%d\nt:%d:%d', ...
                    xyz(2),xyz(5),xyz(1),xyz(4),xyz(3),xyz(6));
                disp(sprintf('crop#: %d',numout));
                disp(str);
            end
        end
    end
    
end