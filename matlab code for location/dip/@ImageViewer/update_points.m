function update_points(obj)
% update/replot the points on the canvas; specifically, adjust the
% lineroi.p according to the imgroi.p

% INPUT:
% obj: ImageViewer obj

    np = size(obj.imgroi.p,2);
    for ii = 1:np
        x = obj.imgroi.p(1,ii,obj.cur_frame);
        y = obj.imgroi.p(2,ii,obj.cur_frame);
        % invalid point
        if isnan(x) || isnan(y) || isinf(x) || isinf(y)
            x = [];
            y = [];
        end
        if numel(obj.lineroi.p)>=ii
            % line obj exists
            if isgraphics(obj.lineroi.p{ii},'line')
                set(obj.lineroi.p{ii},'XData',x,'YData',y)
            end
        else
            % line obj doesn't exist
            obj.lineroi.p{ii} = line('XData',x,'YData',y,...
                                     'Marker',obj.PM,...
                                     'Color',obj.PC,...
                                     'MarkerSize',obj.PS,...
                                     'MarkerFaceColor',obj.PC);
        end
    end
end
