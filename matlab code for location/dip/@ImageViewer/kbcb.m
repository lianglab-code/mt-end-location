function kbcb(obj,src,evt)
    switch lower(evt.Key)
        % built-in functionalities
      case 'escape' % return to general mode
        mode_reset(obj);
      case 'i' % toggle show info
        obj.showinfo_flag = ~obj.showinfo_flag;
      case 'add' % zoom in figure
        zoom_figure(obj.h_fig, obj.MAG_FACTOR);
      case 'subtract' % zoom out figure
        zoom_figure(obj.h_fig, 1/obj.MAG_FACTOR);
      case 'equal' % zoom in axes
        zoom_axes(obj.h_axes, obj.MAG_FACTOR);
      case 'hyphen' % zoom out axes
        zoom_axes(obj.h_axes, 1/obj.MAG_FACTOR);
      case 'uparrow' % increase scroll step
        obj.scroll_step = obj.scroll_step + 1;
      case 'downarrow' % decrease scroll step
        if(obj.scroll_step>1)
            obj.scroll_step = obj.scroll_step - 1;
        end
      case 'c' % imcontrast
        imcontrast(obj.h_img);
      case 'm' % move
        mode_move(obj);
      case 'p' % roip
        mode_roip(obj);
      case 'r' % roir
        mode_roir(obj);
      case 'a' % roia
        mode_roia(obj);
      case 'd' % delete roi
        modifier = lower(evt.Modifier);
        if isempty(modifier)
            if strcmp(obj.cur_mode,'roip')
                delete_point(obj);
                update_points(obj);
            elseif strcmp(obj.cur_mode,'roia')
                delete_arrow(obj);
                update_arrows(obj);
            elseif strcmp(obj.cur_mode,'roir')
                delete_rect(obj);
                update_rects(obj);
            end
        else
            if strcmp(modifier,'control')
                if strcmp(obj.cur_mode,'roip')
                    delete_all_points(obj);
                    update_points(obj);
                elseif strcmp(obj.cur_mode,'roia')
                    delete_all_arrows(obj);
                    update_arrows(obj);
                elseif strcmp(obj.cur_mode,'roir')
                    delete_all_rects(obj);
                    update_rects(obj);
                end
            end
        end
      case 'e' % export rois
        export_var(obj);
      case 'q' % quit
        close(obj.h_fig);
      case 'slash' % kymograph
        if strcmp(obj.cur_mode,'roia')
            obj.kymo();
        end
      case 'k' % operation
        modifier = lower(evt.Modifier);
        if isempty(modifier)
            if strcmp(obj.cur_mode,'roip')
                obj.op_on_point();
            elseif strcmp(obj.cur_mode,'roia')
                obj.op_on_arrow();
            elseif strcmp(obj.cur_mode,'roir')
                % obj.op_on_rect();
            end
        else
            if strcmp(modifier,'shift')
                if strcmp(obj.cur_mode,'roip')
                    obj.op_on_left_points();
                elseif strcmp(obj.cur_mode,'roia')
                    obj.op_on_left_arrows();
                elseif strcmp(obj.cur_mode,'roir')
                    % op_on_left_rects();
                end
            end
        end
      otherwise
        disp('unknown key:');
        disp(evt.Key);
    end
end
