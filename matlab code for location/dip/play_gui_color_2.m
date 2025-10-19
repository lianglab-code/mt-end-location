function play_gui_color_2(red, green)
%% PLAY_GUI play image as movies
% usage: play_gui_color_2(eb1_img, mt_img)
        
%% UI

    [img_height, img_width, num_frames] = size(red);
    num_channels = 3;
    blue=zeros(img_height, img_width, num_frames);
    img = zeros(img_height, img_width, num_channels, num_frames);
    for i = 1:num_frames
        img(:,:,1,i) = red(:,:,i)/max(max(red(:,:,i)));
        img(:,:,2,i) = green(:,:,i)/max(max(green(:,:,i)));
        img(:,:,3,i) = blue(:,:,i);
    end
    
    % Create and then hide the GUI as it is being constructed.
    % [left bottom width height]
    h_main_fig = figure( ...
        'Visible','off', ...
        'Position',[1 1 900 700], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_main_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');
    
    % Initialization
    % Construct the components.
    % 1. Axes
    h_img_axes = axes( ...
        'Parent', h_main_fig, ...
        'Units', 'pixels', ...
        'Position', [50 80 800 600], ...
        'userdata', []);
    set(h_img_axes, 'xtick', [], 'ytick', []); 
    imshow(img(:,:,:,1),[]);
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
    set(h_main_fig, 'Name', 'playing movie');
    movegui(h_main_fig, 'center');
    set(h_main_fig, 'Visible', 'on');

    
    %% Callbacks
    
    function h_img_slider_Callback(src, evt)
        v = round(get(src, 'Value'));
        imshow(img(:,:,:,v), [],  'Parent', h_img_axes);
        drawnow;
    end
    
end
