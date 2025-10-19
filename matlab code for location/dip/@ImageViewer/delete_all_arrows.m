function delete_all_arrows(obj)
% delete all arrows of a selected track
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.a,2)
        % remove all arrows first
        for ii = 1:size(obj.imgroi.a,2)
            delete(obj.lineroi.a{ii});
        end
        obj.lineroi.a = cell(1,0);
        obj.imgroi.a(:,obj.active_ind,:) = [];
        obj.imgroi.a2(:,obj.active_ind,:) = [];
        % update_arrows(obj);
    end
end
