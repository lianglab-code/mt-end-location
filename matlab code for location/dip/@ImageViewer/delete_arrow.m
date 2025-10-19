function delete_arrow(obj)
% delete selected arrow
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.a,2)
        obj.imgroi.a(:,obj.active_ind,obj.cur_frame) = nan;
        obj.imgroi.a2(:,obj.active_ind,obj.cur_frame) = nan;
        set(obj.lineroi.a{obj.active_ind},'XData',[],'YData',[]);
    end
end
