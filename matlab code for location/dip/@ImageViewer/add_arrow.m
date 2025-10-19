function add_arrow(obj,x1,y1,x2,y2) % p1 points to p2
    xy = repmat([x1;y1;x2;y2], [1 1 obj.num_frames]);
    xy2 = repmat(...
        [x1;y1;nan;atan2(y1-y2,x1-x2);nan(4,1)], ...
        [1 1 obj.num_frames]);
    obj.imgroi.a(:,end+1,:)=xy;
    obj.imgroi.a2(:,end+1,:) = xy2;
    update_arrows(obj);
end
