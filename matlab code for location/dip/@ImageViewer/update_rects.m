function update_rects(obj)
% update/replot the rectangles on the canvas; specifically, adjust
% the lineroi.r according to the imgroi.r

% INPUT:
% obj: ImageViewer obj

    nr = size(obj.imgroi.r,2);
    cur_frame = obj.cur_frame;
    for ii = 1:nr
        x = obj.imgroi.r(1,ii,cur_frame);
        y = obj.imgroi.r(2,ii,cur_frame);
        w = obj.imgroi.r(3,ii,cur_frame);
        h = obj.imgroi.r(4,ii,cur_frame);
        if sum(isnan([x y w h]))>0 ||...
                sum(isinf([x y w h]))>0
            rectx = [];
            recty = [];
        end
        rectx = [x x+w x+w x x];
        recty = [y y y+h y+h y];
        if numel(obj.lineroi.r)>=ii
            if isgraphics(obj.lineroi.r{ii},'line')
                set(obj.lineroi.r{ii},'XData',rectx,'YData',recty)
            end
        else
            obj.lineroi.r{ii} = line('XData',rectx,'YData',recty,...
                                     'Marker',obj.RM,...
                                     'Color',obj.RC,...
                                     'MarkerSize',obj.RS);
        end
    end
end
