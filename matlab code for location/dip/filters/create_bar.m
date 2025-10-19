function mask = create_bar(sz,phi,s)
%% CREATE_BAR create an bar mask with gaussian
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

    R = round(sz-1)/2;
    if R*2+1 ~= sz
        error('size must be an odd number');
        return;
    end

    mask = zeros(sz,sz);
    [X,Y] = meshgrid(-R:R,-R:R);
    % R2 = sqrt(X.^2 + Y.^2);
    proj = -X*sin(phi) + Y*cos(phi);
    mask = exp(-proj.^2/(2*s^2));
    % mask = mask/sum(mask(:));
end
