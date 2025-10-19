function [t,m,s] = img_calc_thres(img, sz, varargin)
%% IMG_CALC_THRES calculates the threshold of an image
% [t,m,s] = img_calc_thres(img, p_sz)
%
% INPUT:
% img: 2d image
% sz: patch size, s or [h w]
% sigma_level
%
% OUTPUT:
% t: threshold, default mean + 2*std
% m: mean of background
% s: std of background
%
% ASSUMPTION:
% The image should have subtracted background.
% The background has lower intensity.
% There are two clusters: object and background.
% This method uses GMM (2d, std and quantile) to cluster the
% patches.
% The threshold is calculated by the Otsu method with object
% patches.
% There are enough patches containing objects.
%
% EXAMPLE:
% FWHM = 7; % 7 pixels, determined from image by the user
% PATCH_SIZE = 3*FWHM; % FWHM*3
% THRES_SIGMA = 2.5; % to determine the threshold
% t = img_calc_thres(img, PATCH_SIZE, THRES_SIGMA);
% img_thres = img>t;

SIGMA_LEVEL = 2;
if nargin>2
    SIGMA_LEVEL = varargin{1};
end

t = 0;
[p, p_sz] = img_patch(img,sz,true);
p_stat = img_patch_stat(p,p_sz);
stat_m = p_stat.mean;
stat_s = p_stat.std;
stat_q = p_stat.quantile;
gmm = gmdistribution.fit([stat_s,stat_q],2);
cluster_sq = cluster(gmm,[stat_s,stat_q]);
mu = gmm.mu;
% choose the background cluster index
if mu(1,2)<mu(2,2)
    cluster_ind = 1;
else
    cluster_ind = 2;
end

m = mean(stat_m(cluster_sq==cluster_ind));
s = mean(stat_s(cluster_sq==cluster_ind));
t = m+SIGMA_LEVEL*s;

