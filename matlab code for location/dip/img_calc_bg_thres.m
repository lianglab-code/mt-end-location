function thres = img_calc_bg_thres(img,varargin)
%% IMG_CALC_BG_THRES calcualtes the threshold of the background
% thres = img_calc_bg_thres(img,sigma_level)
%
% Input:
% img: image
% [sigma_level]: sigma level
%
% Output:
% thres: the threshold
%
% Assumption:
% The size occupied by the background out-weights the size of
% target

if nargin>1
    sigma_level = varargin{1};
else
    sigma_level = 3;
end

gmm = gmdistribution.fit(img(:),1);
thres = gmm.mu + sigma_level * gmm.Sigma;

