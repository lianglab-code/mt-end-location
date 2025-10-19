function op_on_arrow(obj)
% just a wrapper
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.a,2)
        [p,param] = obj.localize_endpoint();
        if sum(isnan(p))==0
            p1 = reshape(p,[2 1]);
            p2 = p + ImageViewer.ABL*...
                 [cos(param(4)+pi);...
                  sin(param(4)+pi)];
            obj.imgroi.a(:,obj.active_ind,obj.cur_frame) = [p1;p2];
            obj.imgroi.a2(:,obj.active_ind,obj.cur_frame) = param;
            obj.update_arrows();
        end
    end
end
