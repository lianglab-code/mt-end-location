function [d,ind] = calc_closest_point(obj,x,y)
% find the closest point from point [x;y]
    d = 0;
    ind = 0; % 0 indicates NA
    np = size(obj.imgroi.p,2);
    if np==0
        return;
    end
    p = [x;y];
    ps = obj.imgroi.p(:,:,obj.cur_frame);
    d2 = bsxfun(@minus,ps,p);
    d2 = sum(d2.^2,1);
    [d,ind] = min(d2,[],2);
    d = sqrt(d);
    if isnan(d) || isnan(ind) || isinf(d) || isinf(ind)
        d = 0;
        ind = 0;
    end
end
