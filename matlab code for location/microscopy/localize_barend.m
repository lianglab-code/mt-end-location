function xy = localize_barend(imgs)
%% LOCALIZE_BAREND estimates the end of filaments
%
% Input:
% imgs: image series
% 
% Output:
% xy: num_frames x 2

    options = struct;
    options.crop_radius = 6;

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
    scaling_factor = size(kimg,2)...
        /sqrt( sum( (xys(:,end)-xys(:,1)).^2 ) );
    d_t = get_poly_line(kimg); % initial guess

    % 3.1 polyline to initial guess
    t_bks = round(d_t(:,2));
    for ii = 2:numel(t_bks)
        ind2 = t_bks(ii);
        ind1 = t_bks(ii-1);
        if ind2 < ind1
            continue;
        elseif ind2 == ind1
            tmpd = ((d_t(ii-1,1)+d_t(ii,1))/2)/scaling_factor;
            xy0(t_bks(ii-1),:) = p12(1,:) ...
                + tmpd*[cos(p12_theta),sin(p12_theta)];
        else
            dd_dt = ( d_t(ii,1)-d_t(ii-1,1) )...
                    /( d_t(ii,2)-d_t(ii-1,2) );
            tmpd = d_t(ii-1,1) + ...
                   dd_dt ...
                   * ( (t_bks(ii-1):(t_bks(ii)-1))'...
                       -d_t(ii-1,2) );
            xy0(ind1:(ind2-1),:) = ...
                repmat(p12(1,:),ind2-ind1,1) ...
                + tmpd/scaling_factor...
                *[cos(p12_theta),sin(p12_theta)];
        end
    end

    % 4. coarse center
    calc_flag = ~isnan(xy0(:,1)) & ~isnan(xy0(:,2));
    current_line = [p12(1,1)+sqrt(-1)*p12(1,2);...
                    p12(2,1)+sqrt(-1)*p12(2,2)];
    coarse_centers = xy0(:,1) + sqrt(-1)*xy0(:,2);

    % 5. precise center
    %    todo: to export params instead of xy?
    params = fit_mt_end(imgs,...
                        options.crop_radius,...
                        coarse_centers,...
                        current_line,...
                        calc_flag);
    xy = params(:,1:4);
end
