function add_point(obj,x,y)
    xy = repmat([x;y], [1 1 obj.num_frames]);
    obj.imgroi.p(:,end+1,:)=xy;
    update_points(obj);
end
