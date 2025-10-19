function delete_all_points(obj)
% delete all points of a selected track
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.p,2)
        % remove all points first
        for ii = 1:size(obj.imgroi.p,2)
            delete(obj.lineroi.p{ii});
        end
        obj.lineroi.p = cell(1,0);
        obj.imgroi.p(:,obj.active_ind,:) = []; % remove the column
        % update_points(obj);
    end
end
