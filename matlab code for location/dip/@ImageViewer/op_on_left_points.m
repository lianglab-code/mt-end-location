function op_on_left_points(obj)
% just a wrapper
    if obj.active_ind>0 && ...
            obj.active_ind<=size(obj.imgroi.p,2)
        disp(strcat('Computing: Localizing left points:',...
                    num2str(obj.active_ind))); % start
        params = obj.localize_left_points();
        if ~isempty(params)
            obj.imgroi.p(:,obj.active_ind,obj.cur_frame:end) = ...
                params(1:2,:,obj.cur_frame:end);
            obj.update_points();
        end
        disp('done'); % end
    end
end
