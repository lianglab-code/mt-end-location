function play_gui_color(img)
%% PLAY_GUI play image as movies
% img: the images to be played
        
%% UI

    sz_img = size(img);
    if numel(sz_img)<4
        error('Single frame or single channel, aborted');
        return;
    end
    
    [img_height, img_width, num_channels num_frames] = size(img);
    if num_channels>3
        error('more than 3 channels');
        return;
    elseif num_channels==2
        img2 = zeros(img_height, img_width, 3, num_frames);
        for i = 1:num_frames
            img2(:,:,1,i) = img(:,:,1,i)/max(max(img(:,:,1,i)));
            img2(:,:,2,i) = img(:,:,2,i)/max(max(img(:,:,2,i)));
        end
        img = img2;
        clear 'img2';
    else
        for i = 1:num_frames
            img(:,:,1,i) = img(:,:,1,i)/max(max(img(:,:,1,i)));
            img(:,:,2,i) = img(:,:,2,i)/max(max(img(:,:,2,i)));
            img(:,:,3,i) = img(:,:,3,i)/max(max(img(:,:,3,i)));
        end
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
    imshow(img(:,:,:,1));
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
        imshow(img(:,:,:,v), 'Parent', h_img_axes);
        drawnow;
    end
    
end
