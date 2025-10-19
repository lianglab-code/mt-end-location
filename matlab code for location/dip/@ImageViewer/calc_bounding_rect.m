function ind = calc_bounding_rect(obj,x,y)
% find the rect that covers point [x;y]
    ind = 0; % 0 indicates NA
    nr = size(obj.imgroi.r,2);
    if nr==0
        return;
    end
    for ii = 1:nr
        xywh = squeeze(obj.imgroi.r(:,ii,obj.cur_frame));
        p1x = xywh(1);
        p1y = xywh(2);
        p2x = xywh(1)+xywh(3);
        p2y = xywh(2)+xywh(4);
        if x>=p1x && x<=p2x && y>=p1y && y<=p2y
            ind = ii;
            return;
        end
    end
end
