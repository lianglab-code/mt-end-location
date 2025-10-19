function xy0 = estimate_barend(imgs)
%% ESTIMATE_BAREND estimates the end of filaments
%
% Input:
% imgs: image series
% 
% Output:
% xy0: num_frames x 2

    [img_h,img_w,num_frames] = size(imgs);
    xy0 = nan(num_frames,2);

    maximg = max(imgs,[],3);
    q1 = quantile(maximg(:),0.1);
    q2 = quantile(maximg(:),0.9);
    maximg2 = (maximg-q1)/(q2-q1);
    p12 = get_line(maximg2);
    p12_theta = atan2(p12(2,2)-p12(1,2),p12(2,1)-p12(1,1));

    % 3. plot kymo to get initial guess
    [kimg,xys] = kymograph(imgs,p12(1,:),p12(2,:));
    ds = sqrt(sum((xys-xys(:,1)).^2,1)); % distanct to the beginning
    np = numel(ds);
    d_t = get_poly_line(kimg); % initial guess

    % 3.1 polyline to initial guess
    t_bks = round(d_t(:,2));
    for ii = 2:numel(t_bks)
        ind2 = t_bks(ii);
        ind1 = t_bks(ii-1);
        if ind2 < ind1
            continue;
        elseif ind2 == ind1
            tmpd = (d_t(ii-1,1)+d_t(ii,1))/2;
            xy0(t_bks(ii-1),:) = p12(1,:) ...
                + tmpd*[cos(p12_theta),sin(p12_theta)];
        else
            dd_dt = (d_t(ii,1)-d_t(ii-1,1))...
                    /(d_t(ii,2)-d_t(ii-1,2));
            tmpd = d_t(ii-1,1) + ...
                   dd_dt ...
                   * ((t_bks(ii-1):(t_bks(ii)-1))'-d_t(ii-1,2));
            xy0(ind1:(ind2-1),:) = p12(1,:) ...
                + tmpd*[cos(p12_theta),sin(p12_theta)];
        end
    end

end
