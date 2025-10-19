function delete_all_rects(obj)
% delete all rectangles of a selected track
    if obj.active_ind>0 && obj.active_ind<=size(obj.imgroi.r,2)
        for ii = 1:size(obj.imgroi.r,2)
            delete(obj.lineroi.r{ii});
        end
        obj.lineroi.r = cell(1,0);
        obj.imgroi.r(:,obj.active_ind,:) = [];
    end
end
