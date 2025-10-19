function op_on_point(obj)
% just a wrapper
    if obj.active_ind>0 && ...
            obj.active_ind<=size(obj.imgroi.p,2)
        [p,param] = obj.localize_point();
        if sum(isnan(p))==0
            obj.imgroi.p(:,obj.active_ind,obj.cur_frame) = p;
            obj.update_points();
        end
    end
end
