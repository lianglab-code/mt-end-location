function mask = create_barend(sz,phi,s)
%% CREATE_BAREND create an bar-end mask with gaussian
% cross-section.
%
% Input:
% sz: size of the mask, odd integer
% phi: rotation angle in rad, image axis
% s: sigma
% 
% Output:
% mask: mask with maximum value 1;
%
% NOTE: different from FilamentTip2D 
% __________ ___________
%           \  phi
%            \
%             \

    R = round(sz-1)/2;
    if R*2+1 ~= sz
        error('size must be an odd number');
        return;
    end

    mask = zeros(sz,sz);
    [X,Y] = meshgrid(-R:R,-R:R);
    % bar part
    proj = -X*sin(phi) + Y*cos(phi);
    mask1 = exp(-proj.^2/(2*s^2));
    % mask = mask/sum(mask(:));
    % end part
    R2 = sqrt(X.^2 + Y.^2);
    mask2 = exp(-R2.^2/(2*s^2));
    % the boundary of the bar and the end
    proj2 = X*cos(phi) + Y*sin(phi);
    % 
    mask = mask1.*(proj2>=0) + mask2.*(proj2<0);
end
