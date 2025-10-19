function imgroi = paths2imgroi(ps,paths)
%% PATHS2IMGROI converts the paths cells to imgori struct, which
% can be visualized by imviewer.m
%
% Input:
% ps: cells of points, each cell np x 2
% paths: cells of paths result of the connect_paths.m
%
% Output:
% imgroi: a struct with a filed p, used as arg in imviewer.m
%         2 x n_paths x num_frames

    num_frames = numel(ps);
    num_paths = numel(paths);
    p = nan(2,num_paths,num_frames);
    for ii = 1:num_paths
        pp = paths{ii};
        num_ptrs = size(pp,1);
        for jj = 1:num_ptrs
            frame_ind = pp(jj,1);
            ptr_ind = pp(jj,2);
            xy = ps{frame_ind}(ptr_ind,:);
            p(:,ii,frame_ind) = xy';
        end
    end
    imgroi.p = p;
end
