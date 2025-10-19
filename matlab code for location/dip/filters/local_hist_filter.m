function img_out = local_hist_filter(img,w_sz,varargin)
%% LOCAL_HIST_FILTER applies local historgram filter proposed by
% Kass and Solomon
%
% NOT FINISHED
%
% img_out = local_hist_filter(img,w_sz,[n_bin])
%
% INPUT:
% img: 2d image
% w_sz: window size, odd scalar
% n_bins: number of bins
%
% OUTPUT:
% img_out: filtered image
%
% Method:
% For this testing function, the local histogram filter is
% calculated on patches, rather than on moving window.

[img_h,img_w] = size(img);
r = (w_sz-1)/2; % radius; 
n_bins = 100;
if nargin>2
    n_bins = varargin{1};
end

img_out = zeros(size(img));

% to pad the image to make the patch match
pad_h = img_h - floor(img_h/w_sz)*w_sz;
pad_w = img_w - floor(img_w/w_sz)*w_sz;
img2 = padarray(img,[pad_h,pad_w],'circular','post');

[p, sz_p] = img_patch(img2,w_sz);

v = zeros(w_sz*w_sz,1); % intensity values
N = zeros(n_bins,1); % local histogram, count
X = zeros(n_bins,1); % local histogram, coord

G_SIGMA = 1;
GX = [-2;-1;0;1;2];
GY = exp(-(GX.^2)/2*G_SIGMA^2);
GY = GY/sum(GY);

for ii = 1:sz_p
    v = reshape(p(:,:,ii),[w_sz*w_sz,1]);
    [N,X] = hist(v,n_bins);
    N = conv(N,GY,'same');
    [pks,locs] = findpeaks(N);
end