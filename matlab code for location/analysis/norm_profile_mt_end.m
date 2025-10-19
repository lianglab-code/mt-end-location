function [line_profile,mt_len] = norm_profile_mt_end(img, varargin)
%% NORM_PROFILE_MT_END normalizes and profiles the intensity of MT
% end image.

% Input:
% img: MT end image
% nm_per_pixel: (optional)

% Output:
% line_profile: normalized center line profile
% mt_len: the length coordinates of MT

nm_per_pixel = 1.0;
if nargin==2
    nm_per_pixel = varargin{1};
end

[M, N] = size(img);
line_profile = zeros(1,N);
mt_len = (1:N)*nm_per_pixel;

mt_max = 0.0;
bg = 0.0;

SS = 2; % magic number for box size
y0 = floor(M/2)+1;
x0 = floor(N/2)+1;
mid_line = img(y0, :);
bg = mean2(img((y0-SS):(y0+SS),floor(N-N/4-SS):floor(N-N/4+SS)));
mid_line = sort(mid_line);
mt_max = mean(mid_line((N-2*SS):N));

line_profile = (img(y0, :) - bg)/(mt_max - bg);

end