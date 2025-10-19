function wbucb(obj,src,evt,varargin)
% point mode
    if strcmp(obj.cur_mode,'roip')
        point_mode = varargin{1};
        if strcmp(point_mode,'move')
            x = get(obj.lineroi.p{obj.active_ind},'XData');
            y = get(obj.lineroi.p{obj.active_ind},'YData');
            obj.imgroi.p(:,obj.active_ind,obj.cur_frame) = [x;y];
        elseif strcmp(point_mode,'add')
            tmppoint = varargin{2};
            x = get(tmppoint,'XData');
            y = get(tmppoint,'YData');
            delete(tmppoint);
            add_point(obj,x,y);
            obj.active_ind = size(obj.imgroi.p,2);
        end
        % arrow mode
    elseif strcmp(obj.cur_mode,'roia')
        arrow_mode = varargin{1};
        % arrow move
        if strcmp(arrow_mode,'move')
            arrow_ud = get(...
                obj.lineroi.a{obj.active_ind}, ...
                'UserData');
            x1 = arrow_ud(1);
            y1 = arrow_ud(2);
            x2 = arrow_ud(4);
            y2 = arrow_ud(5);
            obj.imgroi.a(:,obj.active_ind,obj.cur_frame) = ...
                [x1;y1;x2;y2];
            % arrow add
        elseif strcmp(arrow_mode,'add')
            tmparrow = varargin{2};
            arrow_ud = get(...
                tmparrow, ...
                'UserData');
            x1 = arrow_ud(1);
            y1 = arrow_ud(2);
            x2 = arrow_ud(4);
            y2 = arrow_ud(5);
            delete(tmparrow);
            add_arrow(obj,x1,y1,x2,y2);
            obj.active_ind = size(obj.imgroi.a,2);
        end
        % rect mode
    elseif strcmp(obj.cur_mode,'roir')
        rect_mode = varargin{1};
        % rect move
        if strcmp(rect_mode,'move')
            rectx = get(obj.lineroi.r{obj.active_ind},'XData');
            recty = get(obj.lineroi.r{obj.active_ind},'YData');
            [x,y,w,h] = rect_line2roi(rectx,recty);
            obj.imgroi.r(:,obj.active_ind,obj.cur_frame) = ...
                [x;y;w;h];
            % rect add
        elseif strcmp(rect_mode,'add')
            tmprect = varargin{2};
            rectx = get(tmprect,'XData');
            recty = get(tmprect,'YData');
            delete(tmprect);
            [x,y,w,h] = rect_line2roi(rectx,recty);
            add_rect(obj,x,y,w,h);
            obj.active_ind = size(obj.imgroi.r,2);
        end
    end
    set(obj.h_fig,'WindowButtonMotionFcn','',...
                  'WindowButtonUpFcn','');
end
