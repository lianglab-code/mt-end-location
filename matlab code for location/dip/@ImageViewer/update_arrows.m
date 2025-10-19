function update_arrows(obj)
% update/replot the arrows on the canvas; specifically, adjust the
% lineroi.a according to the imgroi.a

% INPUT:
% obj: ImageViewer obj

    na = size(obj.imgroi.a,2);
    cur_frame = obj.cur_frame;
    for ii = 1:na
        x1 = obj.imgroi.a(1,ii,cur_frame);
        y1 = obj.imgroi.a(2,ii,cur_frame);
        x2 = obj.imgroi.a(3,ii,cur_frame);
        y2 = obj.imgroi.a(4,ii,cur_frame);
        % invalid points
        if sum(isnan([x1 y1 x2 y2]))>0 || ...
                sum(isinf([x1 y1 x2 y2]))>0
            x1 = [];
            y1 = [];
            x2 = [];
            y2 = [];
        end
        if numel(obj.lineroi.a)>=ii
            % arrow exists
            if isgraphics(obj.lineroi.a{ii},'patch')
                if isempty(x1) || isnan(x1)
                    set(obj.lineroi.a{ii},'XData',[],...
                                      'YData',[]);
                    % Something inconsistent might happen,
                    % because the Start and Stop of the
                    % userdata of the arrow object have not
                    % been updated.
                else
                    arrow(obj.lineroi.a{ii},...
                          'Start',[x1 y1],...
                          'Stop',[x2 y2]);
                end
            end
        else
            % arrow doesn't exist
            if isnan(x1)
                obj.lineroi.a{ii} = arrow('Start',[0 0],...
                                          'Stop',[0 0],...
                                          'Color',obj.AC,...
                                          'Width',obj.ALW,...
                                          'Length',obj.AHL);
            else
                obj.lineroi.a{ii} = arrow('Start',[x1 y1],...
                                          'Stop',[x2 y2],...
                                          'Color',obj.AC,...
                                          'Width',obj.ALW,...
                                          'Length',obj.AHL);
            end
        end
    end
end
