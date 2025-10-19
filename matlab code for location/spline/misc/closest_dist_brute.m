function [dist, ind] = closest_dist_brute(query, subject)
%% CLOSEST_DIST_BRUTE calculates the closest distance from a point
% in the query point set to the subjest point set. The distance is
% the Euclidean distance.

% INPUT:
% query: query point set, 2xn or 3xn
% subject: subect point set, 2xm or 3xm

% OUTPUT:
% dist: the closest distance from the point in the query to subject
% ind: the index of the point in subect point set

% EXAMPLE:
% tmp1 = rand(2,8);
% tmp2 = 2*rand(2,8);
% [dist ind] = closest_dist_brute(tmp1,tmp2);
% v = zeros(size(tmp1));
% for ii = 1:size(tmp1,2)
% v(:,ii) = tmp2(:,ind(ii)) - tmp1(:,ii);
% end
% figure;hold on;
% plot(tmp1(1,:),tmp1(2,:),'ro');
% plot(tmp2(1,:),tmp2(2,:),'k*');
% quiver(tmp1(1,:),tmp1(2,:),v(1,:),v(2,:),0,'b')

MAX_NUM = 500;

[dim, num_query] = size(query);
if(dim~=2 && dim~=3)
    error('query point set should be 2xn or 3xn');
end

[tmp, num_subject] = size(subject);
if(tmp~=2 && tmp~=3)
    error('subject point set should be 2xn or 3xn');
end
if(tmp~=dim)
    error('subject point and query point should have the same dimension');
end

if(num_query > MAX_NUM || num_subject > MAX_NUM)
    MAX_NUM
    error('too much points, check MAX_NUM');
end

dist = zeros(1,num_query);
ind = zeros(1,num_query);

for II = 1:num_query
    src = repmat(query(:,II), 1, num_subject);
    diff = src-subject;
    dist2 = sum(diff.*diff,1);
    [min_dist, min_ind] = min(dist2);
    dist(II) = min_dist;
    ind(II) = min_ind;
end