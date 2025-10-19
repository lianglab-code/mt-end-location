function mode_move(obj,varargin)
% move
% because this helper uses move_axes func, it needs more work
    if(strcmp(obj.cur_mode,'move_axes'))
        if(nargin==2 && strcmp(varargin{1},'off'))
            move_axes(obj.h_axes,'off');
        end
        return;
    else
        mode_reset(obj);
        obj.cur_mode = 'move_axes';
        xylimit = [0.5 obj.img_w+0.5 0.5 obj.img_h+0.5];
        move_axes(obj.h_axes,xylimit);
    end
end
