function img = img_montage(R,varargin)
%% IMG_MONTAGE makes a squard montage from input multi-frame images
%
% Input
% R: multi-frame images
% [G,B]: extra images
% 
% Output
% img: the montage, horizon is the fastest changing dim

% montage image size limit
MAX_M = 2048;
MAX_N = 2048;

img = [];
[M,N,L] = size(R);
grid = ceil(sqrt(L));
MM = M*grid; % montage M
NN = N*grid; % montage N

% size limit checking
if MM > MAX_M || NN > MAX_N
    warning('the image is too large');
    return;
end

num_channels = nargin;
img = zeros(MM,NN,num_channels);

% dimension checking
for ii = 1:(num_channels-1)
    [u,v,w] = size(varargin{ii});
    if sum(abs([M,N,L]-[u,v,w])) ~= 0
        warning('dimension mismatch');
        return;
    end
end

% the first channel
ii = 1;
for jj = 1:L
    % % should have used ind2sub
    % col = mod(jj-1,grid)+1;
    % row = 1 + (jj - col)/grid;
    % [m,n] = ind2sub([grid,grid],jj);
    % swap M-N
    [n,m] = ind2sub([grid,grid],jj);
    m0 = 1 + (m-1)*M;
    m1 = m*M;
    n0 = 1 + (n-1)*N;
    n1 = n*N;
    img(m0:m1,n0:n1,ii) = R(:,:,jj);
end

for ii = 1:(num_channels-1)
    R = varargin{ii};
    for jj = 1:L
        [n,m] = ind2sub([grid,grid],jj);
        m0 = 1 + (m-1)*M;
        m1 = m*M;
        n0 = 1 + (n-1)*N;
        n1 = n*N;
        img(m0:m1,n0:n1,ii+1) = R(:,:,jj);
    end
end