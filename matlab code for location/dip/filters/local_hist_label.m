function img_out = local_hist_label(img,w_sz,varargin)
%% LOCAL_HIST_LABEL uses local historgram to segment image
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

% find background information
NUM_CLASSES = 2;
gmm = gmdistribution.fit(img(:),NUM_CLASSES);
[~,ind] = max(gmm.ComponentProportion);
bg_mean = gmm.mu(ind);
bg_std = sqrt(gmm.Sigma(ind));

% to pad the image to make the patch match
pad_h = ceil(img_h/w_sz)*w_sz - img_h;
pad_w = ceil(img_w/w_sz)*w_sz - img_w;
img2 = padarray(img,[pad_h,pad_w],'circular','post');

[p, sz_p] = img_patch(img2,w_sz);
p2 = zeros(size(p));

v = zeros(w_sz*w_sz,1); % intensity values
N = zeros(n_bins,1); % local histogram, count
X = zeros(n_bins,1); % local histogram, coord

G_SIGMA = 2*bg_std;
% GX = [-2;-1;0;1;2];
% GX = reshape([-3:3],[7,1]);
GX = -round(G_SIGMA*6):round(G_SIGMA*6);
GX = reshape(GX,[numel(GX),1]);
GY = exp(-(GX.^2)/2*G_SIGMA^2);
GY = GY/sum(GY);

MinPeakHeight = 10/w_sz^2;

for ii = 1:size(p,3)
    v = reshape(p(:,:,ii),[w_sz*w_sz,1]);
    % [N,X] = hist(v,n_bins);
    [N,X] = histcounts(v);
    N = N/(w_sz*w_sz); % normalization
    N = conv(N,GY,'same');
    % [pks,locs] = findpeaks(N,'MinPeakHeight',MinPeakHeight);
    [pks,locs] = findpeaks(N);
    x = X(locs);
    if numel(x)==0
        x = reshape([X(1) X(end)],[1,1,2]);
    else
        x = reshape(x,[1,1,numel(x)]);
    end
    tmp = abs(bsxfun(@minus,p(:,:,ii),x));
    [~,indx] = min(tmp,[],3);
    p2(:,:,ii) = reshape(x(indx),[w_sz,w_sz]);
end

tmpimg = img_patch_synt(p2,sz_p);
img_out = tmpimg(1:img_h,1:img_w);