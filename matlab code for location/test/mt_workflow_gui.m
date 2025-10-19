function mt_workflow_gui
%% MT_WORKFLOW_GUI is the main window of the whole proram.

%% Features list
% * chromatic correction
% * drift correction
% * mt end determination
% 

%% Add current path to MATLAB PATH
    add_paths('.');

    %% Global vars declaration
    % global vars are messages commucated between sub-GUI

    % parameters
    global gb_params;
    gb_params.border_px = 10;
    gb_params.crop_radius_px = 6;
    gb_params.kymograph_n = 100; % num of points in kymo profile
    gb_params.kymograph_d = 0; % half width of the line profile
    gb_params.mt_sigma = 0; % half width of the mt end
    gb_params.fit_cropped_r = 8; % cropped radius
    gb_params.fit_d = 1; % half width of the line profile for erfc


    % setup/
    global GB_NM_PER_PIXEL GB_TIME_INTERVAL;

    % load_images/
    global gb_mt_imgs gb_map_imgs;
    global gb_mt_file gb_map_file;

    % calc_tform/
    global gb_bead_file_list gb_bead_file_num gb_tform;

    % correct_red/
    global gb_bead_file_list;
    global gb_bead_file_num;
    
    % correct_drift/
    global gb_imagej_tf_file;

    % add_line/
    global gb_mt_lines;
    
    % calc_mt_end/
    global gb_mt_end_params;


    %% GUI

    % main window
    h_workflow_fig = figure( ...
        'Name', 'MT Workflow', ...
        'NumberTitle', 'off', ...
        'Visible','off', ...
        'Position',[1 1 200 400], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_workflow_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');

    % task buttons
    num_butt = 12;
    current_butt = 0;
    pbutts = [];
    pbutt_width = 140;
    pbutt_height = 40;
    pbutt_margin = 20;
    set(h_workflow_fig, 'Position', ...
                      [1 1 ...
                       pbutt_margin*2+pbutt_width ...
                       (pbutt_margin+pbutt_height)*num_butt+pbutt_margin]);

    % 01 setup push button
    current_butt = current_butt + 1;
    str = 'Setup';
    h_setup_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                pbutt_height, pbutt_margin, str, ...
                                h_workflow_fig);
    set(h_setup_pbutt, 'Callback', @h_setup_pbutt_Callback);
    pbutts(current_butt) = h_setup_pbutt;

    % 02 load or save mat push button
    current_butt = current_butt + 1;
    str = 'Load/Save';
    h_load_save_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                    pbutt_height, pbutt_margin, str, ...
                                    h_workflow_fig);
    set(h_load_save_pbutt, 'Callback', @h_load_save_pbutt_Callback);
    pbutts(current_butt) = h_load_save_pbutt;


    % 03 load images push button
    current_butt = current_butt + 1;
    str = 'Load Images';
    h_load_images_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                      pbutt_height, pbutt_margin, str, ...
                                      h_workflow_fig);
    set(h_load_images_pbutt, 'Callback', @h_load_images_pbutt_Callback);
    pbutts(current_butt) = h_load_images_pbutt;

    % 04 calc tform push button
    current_butt = current_butt + 1;
    str = 'Calc Tform';
    h_calc_tform_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                     pbutt_height, pbutt_margin, str, ...
                                     h_workflow_fig);
    set(h_calc_tform_pbutt, 'Callback', @h_calc_tform_pbutt_Callback);
    pbutts(current_butt) = h_calc_tform_pbutt;

    % 05 correct red push button
    current_butt = current_butt + 1;
    str = 'Correct Red';
    h_correct_red_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                      pbutt_height, pbutt_margin, str, ...
                                      h_workflow_fig);
    set(h_correct_red_pbutt, 'Callback', @h_correct_red_pbutt_Callback);
    pbutts(current_butt) = h_correct_red_pbutt;

    % 06 inv correct red push button
    current_butt = current_butt + 1;
    str = 'Inv Corr Red';
    h_inv_correct_red_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                          pbutt_height, pbutt_margin, str, ...
                                          h_workflow_fig);
    set(h_inv_correct_red_pbutt, 'Callback', @h_inv_correct_red_pbutt_Callback);
    pbutts(current_butt) = h_inv_correct_red_pbutt;

    % 07 correct drift push button
    current_butt = current_butt + 1;
    str = 'Coorect Drift';
    h_correct_drift_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                        pbutt_height, pbutt_margin, str, ...
                                        h_workflow_fig);
    set(h_correct_drift_pbutt, 'Callback', @h_correct_drift_pbutt_Callback);
    pbutts(current_butt) = h_correct_drift_pbutt;

    % 08 add line push button
    current_butt = current_butt + 1;
    str = 'Add MT Line';
    h_add_line_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                   pbutt_height, pbutt_margin, str, ...
                                   h_workflow_fig);
    set(h_add_line_pbutt, 'Callback', @h_add_line_pbutt_Callback);
    pbutts(current_butt) = h_add_line_pbutt;

    % 09 add kymograph push button
    current_butt = current_butt + 1;
    str = 'Add Kymograph';
    h_add_kymograph_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                        pbutt_height, pbutt_margin, str, ...
                                        h_workflow_fig);
    set(h_add_kymograph_pbutt, 'Callback', @h_add_kymograph_pbutt_Callback);
    pbutts(current_butt) = h_add_kymograph_pbutt;

    % 10 calc MT end push button
    current_butt = current_butt + 1;
    str = 'Calc MT End';
    h_calc_mt_end_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                      pbutt_height, pbutt_margin, str, ...
                                      h_workflow_fig);
    set(h_calc_mt_end_pbutt, 'Callback', @h_calc_mt_end_pbutt_Callback);
    pbutts(current_butt) = h_calc_mt_end_pbutt;

    % 11 Analysis push button
    current_butt = current_butt + 1;
    str = 'Analysis';
    h_analysis_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                   pbutt_height, pbutt_margin, str, ...
                                   h_workflow_fig);
    set(h_analysis_pbutt, 'Callback', @h_analysis_pbutt_Callback);
    pbutts(current_butt) = h_analysis_pbutt;

    % 12 other analysis push button
    current_butt = current_butt + 1;
    str = 'Other Analysis';
    h_other_analysis_pbutt = add_pbutton(num_butt, current_butt, pbutt_width, ...
                                         pbutt_height, pbutt_margin, ...
                                         str, h_workflow_fig);
    set(h_other_analysis_pbutt, 'Callback', @h_other_analysis_pbutt_Callback);
    pbutts(current_butt) = h_other_analysis_pbutt;


    % Display the main window
    movegui(h_workflow_fig, 'center');
    set(h_setup_pbutt, 'Enable', 'on');
    set(h_load_save_pbutt, 'Enable', 'on');
    set(h_workflow_fig, 'Visible', 'on');


    %% Callbacks
    function h_setup_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        setup_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_load_save_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        load_save_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_load_images_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        load_images_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_calc_tform_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        calc_tform_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_correct_red_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        correct_red;
        uiwait(msgbox('Chromatic Correction Done'));
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_inv_correct_red_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        inv_correct_red;
        uiwait(msgbox('Chromatic Correction Done'));
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_correct_drift_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        correct_drift_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_add_line_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        add_line_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_add_kymograph_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        add_kymograph_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_calc_mt_end_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        calc_mt_end;
        uiwait(msgbox('Calc MT End Done'));
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_analysis_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        analysis_gui;
        change_all_pbuttons_state(pbutts,'on');
    end

    function h_other_analysis_pbutt_Callback(src,evt)
        change_all_pbuttons_state(pbutts,'off');
        change_all_pbuttons_state(pbutts,'on');
    end

end