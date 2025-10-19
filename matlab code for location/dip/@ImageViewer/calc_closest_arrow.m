function [d,ind,arrowend] = calc_closest_arrow(obj,x,y)
% find the closest point from point [x;y]
    d = 0;
    ind = 0; % 0 indicates NA
    arrowend = ''; % Start/Stop
    na = size(obj.imgroi.a,2);
    if na==0
        return;
    end
    p = [x;y];
    ps = obj.imgroi.a(:,:,obj.cur_frame);
    ps_1 = ps(1:2,:); % Start points
    ps_2 = ps(3:4,:); % Stop points
                      % Start points
    d2_1 = bsxfun(@minus,ps_1,p);
    d2_1 = sum(d2_1.^2,1);
    [d_1,ind_1] = min(d2_1,[],2);
    % Stop points
    d2_2 = bsxfun(@minus,ps_2,p);
    d2_2 = sum(d2_2.^2,1);
    [d_2,ind_2] = min(d2_2,[],2);
    if d_1<d_2
        d = d_1;
        ind = ind_1;
        arrowend = 'Start';
    else
        d = d_2;
        ind = ind_2;
        arrowend = 'Stop';
    end
    d = sqrt(d);
    if isnan(d) || isnan(ind) || isinf(d) || isinf(ind)
        d = 0;
        ind = 0;
    end
end
