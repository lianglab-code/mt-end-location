function add_rect(obj,x,y,w,h)
    xywh = repmat([x;y;w;h],[1 1 obj.num_frames]);
    obj.imgroi.r(:,end+1,:)=xywh;
    update_rects(obj);
end
