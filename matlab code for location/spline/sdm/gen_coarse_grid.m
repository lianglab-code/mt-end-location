function grids = gen_coarse_grid(pc, sz)
%% GEN_COARSE_GRID generates a partition of the original points.

% INPUT:
% pc: input point cloud, 2xn; originated from an image
% sz: 1x2; number of intervals, e.g., [3 4] 3 columns, 4 rows

% OUTPUT:
% grids: the output grids; struct; 
% grids files:
% int_x: x intervals
% int_y: y intervals
% sz_x: x size
% sz_y: y size
% centers: cell, centers of the grids
% p_ind: cell, the point indices contained in the corresponding grid

% NOTE:
% TODO: It is possible to generate the coarse grid just from the
% point cloud. 
% The grid index is 1-based
% The linear index of grid is column-based ind(i,j) = (j-1)*d1 + i
% If a point lies in ( (i-1)*s , i*s ], it is mapped to i.

% EXAMPLE:
% tmp = min(pc,[],2);
% xmin = tmp(1);
% ymin = tmp(2);
% tmp = max(pc,[],2);
% xmax = tmp(1);
% ymax = tmp(2);
% int_x = grids.int_x;
% int_y = grids.int_y;
% num_grids = numel(grids.centers);
% ColorSet = varycolor(num_grids);
% figure;hold on;
% marker = ['o' '^' '>' '<' '.'];
% num_marker = 5;
% for I = 1:num_grids
% plot(xy(1,grids.p_ind{I}),xy(2,grids.p_ind{I}),...
%      marker(mod(I,num_marker)+1), ...
%      'MarkerSize',8, ...
%      'Color',ColorSet(I,:), ...
%      'MarkerFaceColor',ColorSet(I,:));
% end
% axis equal;
% for I = 1:num_grids
%     cx = grids.centers{I}(1);
%     cy = grids.centers{I}(2);
%     plot(cx,cy,'o','MarkerSize',16,'MarkerFaceColor',ColorSet(I,: ...
%                                                       ));
%     plot([xmin;xmax],[cy-int_y/2;cy-int_y/2],'k:');
%     plot([xmin;xmax],[cy+int_y/2;cy+int_y/2],'k:');
%     plot([cx-int_x/2;cx-int_x/2],[ymin;ymax],'k:');
%     plot([cx+int_x/2;cx+int_x/2],[ymin;ymax],'k:');
% end


[M,N] = size(pc);
if M~=2 && N~=2
    error('input must be 2d point cloud');
    return;
elseif M~=2 && N==2
    pc = pc';
    [M,N] = size(pc);
end

tmp = min(pc,[],2);
xmin = tmp(1);
ymin = tmp(2);
tmp = max(pc,[],2);
xmax = tmp(1);
ymax = tmp(2);

w = xmax - xmin;
h = ymax - ymin;

int_x = w/sz(1);
int_y = h/sz(2);

grids = struct();
grids.int_x = int_x;
grids.int_y = int_y;
grids.sz_x = sz(1);
grids.sz_y = sz(2);

g = zeros(sz);
g_centers = zeros(2,prod(sz)); % linear index, ind = (y-1)*sz_x + x
ind = zeros(1,N); % linear index of grid which contains the point

for I = 1:sz(1) % x dir
    for J = 1:sz(2) % y dir
        g_centers(1, (J-1)*sz(1)+I) = xmin+(I-0.5)*int_x;
        g_centers(2, (J-1)*sz(1)+I) = ymin+(J-0.5)*int_y;
    end
end

pc = pc - repmat([xmin;ymin],[1 N]);

for I = 1:N
    indx = floor(pc(1,I)/int_x)+1;
    indy = floor(pc(2,I)/int_y)+1;
    ind(I) = (indy-1)*sz(1)+indx;
end

grids.centers = {}; % empty cell
grids.p_ind = {};

for I = 1:prod(sz)
    ind_pc = find(ind==I);
    if isempty(ind_pc)
        continue;
    end
    grids.centers{end+1} = g_centers(:,I);
    grids.p_ind{end+1} = ind_pc;
end

end