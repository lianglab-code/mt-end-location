function wbmcb(obj,src,evt,varargin)
    xlim = get(obj.h_axes,'xlim');
    ylim = get(obj.h_axes,'ylim');
    cur_point = get(obj.h_axes,'CurrentPoint');
    x = cur_point(1,1);
    y = cur_point(1,2);
    % point mode
    if strcmp(obj.cur_mode,'roip')
        point_mode = varargin{1};
        % point move mode
        if strcmp(point_mode,'move')
            if x>xlim(1) && x<xlim(2) && ...
                    y>ylim(1) && y<ylim(2)
                set(obj.lineroi.p{obj.active_ind},...
                    'XData',x,...
                    'YData',y);
            end
        elseif strcmp(point_mode,'add')
            tmppoint = varargin{2};
            if x>xlim(1) && x<xlim(2) && ...
                    y>ylim(1) && y<ylim(2)
                set(tmppoint,...
                    'XData',x,...
                    'YData',y);
            end
        end
        % arrow mode, use varargin to distinguish move or add
    elseif strcmp(obj.cur_mode,'roia')
        arrow_mode = varargin{1};
        % rect move
        if strcmp(arrow_mode,'move')
            arrowend = varargin{2}; % I should have check
                                    % arrowend..., is it ''?
            if x>xlim(1) && x<xlim(2) && ...
                    y>ylim(1) && y<ylim(2)
                arrow(obj.lineroi.a{obj.active_ind},...
                      arrowend,[x y]);
            end
            % rect add
        elseif strcmp(arrow_mode,'add')
            tmparrow = varargin{2};
            if x>xlim(1) && x<xlim(2) && ...
                    y>ylim(1) && y<ylim(2)
                arrow(tmparrow,...
                      'Stop',[x y]);
            end
        end
        % rect mode, use varargin to distinguish move or add
    elseif strcmp(obj.cur_mode,'roir')
        rect_mode = varargin{1};
        x0 = varargin{2};
        y0 = varargin{3};
        % rect move
        if strcmp(rect_mode,'move')
            rectx0 = varargin{4};
            recty0 = varargin{5};
            if x>xlim(1) && x<xlim(2) && ...
                    y>ylim(1) && y<ylim(2)
                dx=x-x0;
                dy=y-y0;
                rectx = rectx0+dx;
                recty = recty0+dy;
                set(obj.lineroi.r{obj.active_ind},...
                    'XData',rectx,...
                    'YData',recty);
            end
            % rect add
        elseif strcmp(rect_mode,'add')
            tmprect = varargin{4};
            rectx = [x0 x x x0 x0];
            recty = [y0 y0 y y y0];
            set(tmprect,...
                'XData',rectx,...
                'YData',recty);
        end
    end
end
