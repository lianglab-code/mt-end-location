function delete_rect(obj)
% delete selected rectangle
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.r,2)
        obj.imgroi.r(:,obj.active_ind,obj.cur_frame) = nan;
        set(obj.lineroi.r{obj.active_ind},'XData',[],'YData',[]);
    end
end
