function [A, ins, outs] = simple_ransac_2(p, iter, thres, ...
                                          init_r, in_ratio)
%% SIMPLE_RANSAC_2
% https://en.wikipedia.org/wiki/Random_sample_consensus

% Modification: the initial sampling procedure; for skeletonized images 
% I find candidate points in a circle with a certain radius around
% a random seed; in the wiki page, the candidates are chosen randomly.

% Input:
% p - points, nx2 matrix
% iter - maximum number of iteration
% thres - distance threshold for possible inliers
% init_r - initial selection radius
% in_ratio - estimate of inlier fraction

% Output:
% A: linear model, ax+by+c=0
% ins: inliers, mx2 matrix
% outs: outliers, (n-m)x2 matrix

if size(p,2) ~= 2
    error('p should be nx2 matrix\n');
end

n = size(p,1); % number of points
if n < 2
    error('not enough points\n');
end

if iter>n
    iter = n;
end

% init
A = [0;0;0];
ins = zeros(0,2);
outs = p;
max_in_num = 0;
rand_seq = randperm(n);

for ii = 1:iter
    % find candidates
    seed = p(rand_seq(ii),:);
    dr = p-repmat(seed,[n,1]); % displacement
    idx = (dr(:,1).^2+dr(:,2).^2 < init_r*init_r);
    if size(idx,1) < 2
        continue;
    end
    seeds = p(idx, :); % seeds
    % linear fit; homogeneous line
    [a, b, c, r2] = linear_fit_3(seeds(:,1), ...
                             seeds(:,2));
    % all points are candidates
    candi = p;
    % homogeneous coord
    candi2 = [candi,ones(size(candi,1),1)];
    dists = abs(candi2*[a;b;c]);
    idx_dist = dists<thres;
    ins_tmp = candi(idx_dist,:);
    outs_tmp = candi(~idx_dist,:);
    rms = sqrt(sum(dists.^2)/size(ins_tmp,1)-1);
    n_ins = size(ins_tmp,1);
    if (n_ins/n)>in_ratio && n_ins>max_in_num
        A = [a;b;c];
        ins = ins_tmp;
        outs = outs_tmp;
        max_in_num = n_ins;
        clear 'ins_tmp' 'outs_tmp';
        if size(outs,1)==0
            break;
        end
    end
end

end