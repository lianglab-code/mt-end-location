function delete_point(obj)
% delete the selected point
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.p,2)
        obj.imgroi.p(:,obj.active_ind,obj.cur_frame) = nan;
        set(obj.lineroi.p{obj.active_ind},'XData',[],'YData',[]);
    end
end
