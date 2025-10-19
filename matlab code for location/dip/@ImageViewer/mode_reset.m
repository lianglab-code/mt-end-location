function mode_reset(obj)
% reset
    if(strcmp(obj.cur_mode,'move_axes'))
        % because external mode_move func is used, more work is
        % needed
        mode_move(obj,'off');
    end
    obj.cur_mode = 'general';
    obj.active_ind = 0;
    set(obj.h_fig, ...
        'WindowButtonDownFcn', '', ...
        'WindowButtonMotionFcn', '', ...
        'WindowButtonUpfcn', '');
    set(obj.h_fig,'Pointer','arrow');
end
