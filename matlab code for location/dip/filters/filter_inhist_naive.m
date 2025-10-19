function out = filter_inhist_naive(img,sz,bw,varargin)
%% FILTER_INHIST_NAIVE implements the filter proposed by Kass and
% Solomon using integral histogram.
%
% out = filter_inhist_naive(img,sz)
%
% INPUT:
% img: 2d image, uint8
% sz: window size, scalar or 2-element vector [h,w], odd
% bw: kernel estimation bandwith
% S: convolution kernel radius
% num_bins: number of bins
%
% OUTPUT:
% out: filtered image
%
% NOTE:
% The function uses integral_hist_naive written by Jerviedog.
% This algorithm should also use the corresponding functions
% implemented by VL_FEAT, e.g. vl_inthist and vl_samplinthist.
%
% Performance:
% image: 351x421, sz: 61, bw: 10, S: 6, tic/toc: 82 seconds
% image: 351x421, sz: 61, bw: 30, S: 6, tic/toc: 117 seconds
% image: 351x421, sz: 61, bw: 30, S: 2, tic/toc: 97 seconds
% image: 351x421, sz: 61, bw: 30, S: 1, tic/toc: 83 seconds

if prod(size(sz)) == 1
    h = sz;
    w = sz;
    rh = (h-1)/2;
    rw = (w-1)/2;
elseif prod(size(sz)) == 2
    h = sz(1);
    w = sz(2);
    rh = (h-1)/2;
    rw = (w-1)/2;
else
    error('sz: wrong format');
    return;
end

num_bins = 256; % if max(img(:)) is larger than 255, the value
                % larger than 255 will be ignored
S = 6; % histogram smoothing kernel radisu

if nargin>3
    S = varargin{1};
end

if nargin>4
    num_bins = varargin{2};
end

% to calculate the integral histogram
img2 = padarray(img,[rh,rw],0,'both');
inhist = integral_hist_naive(img2,num_bins);

[H,W] = size(img);
out = zeros(H,W);

% estimation gaussian kernel
GX = -(bw*S):(bw*S);
GX = reshape(GX,[numel(GX),1]);
GY = exp(-(GX.^2)/2*bw^2);
GY = GY/sum(GY);

% findpeaks param
MinPeakHeight = 10;

% sR,sC: starting row and column, padded coord
% eR,eC: ending row and column, padded coord
% ii,jj: original coord
% I,J: padded coord
for jj = 1:W
    J = jj+rw;
    sC = J-rw;
    eC = J+rw;
    for ii = 1:H
        v = double(img(ii,jj)); % image intensity
        I = ii+rh;
        sR = I-rh;
        eR = I+rh;
        % calculate histogram
        hst = inhist(eR+1,eC+1,:) ...
              - inhist(eR+1,sC,:) ...
              - inhist(sR,eC+1,:) ...
              + inhist(sR,sC,:);
        hst = squeeze(hst); % length: 256
        hst2 = conv(hst,GY,'full'); % length: 256+2*bw*S
        % find nearest modes, optional: major, etc
        % [pks,locs] =
        % findpeaks(hst2,'MinPeakHeight',MinPeakHeight);
        [pks,locs] = findpeaks(hst2);
        locs = locs - bw*S - 1;
        [~,ind] = min(abs(locs-v));
        out(ii,jj) = locs(ind);
    end
end
