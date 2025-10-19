function mask = create_annulus(sz,r,s)
%% CREATE_ANNULUS create an annulus mask with gaussian
% cross-section.
%
% Input:
% sz: size of the mask, odd integer
% r: radius
% s: sigma
% 
% Output:
% mask: mask with maximum value 1;
%
% Example:
% FWHM = 3;
% r = 5;
% s = FWHM/(2*sqrt(2*log(2)));
% m = create_annulus(2*round(r+3*s)+1, r, s);
% m = m/sum(m(:)); % normalization

    R = round(sz-1)/2;
    if R*2+1 ~= sz
        error('size must be an odd number');
        return;
    end

    mask = zeros(sz,sz);
    [X,Y] = meshgrid(-R:R,-R:R);
    R2 = sqrt(X.^2 + Y.^2);
    mask = exp(-(R2-r).^2/(2*s^2));
    % mask = mask/sum(mask(:));
end
