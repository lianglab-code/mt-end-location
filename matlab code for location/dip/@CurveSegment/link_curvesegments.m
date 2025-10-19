function Csout = link_curvesegments(Csin,r,k_thres,spreg)
%% LINK_CURVESEGMENTS links broken curve segments
%
% Csout = link_curvesegments(Csin,r,t)
%
% Input:
% Csin: cell of CurveSegment
% r: radius of the search region for close points
% k_thres: maximum curvature of the connection of two curve
% spreg: spline regularization in csaps
%
% Output:
% Csout: cell of CurveSegment
%
% Requirement:
% lapjv, csaps
%
% example inputs:
% r: 5, t: pi/9, l: 7, spreg: 0.1
%
% params
    if numel(Csin)==0
        Csout = {};
        return
    end

    addpath('/home/image/programming/matlab/optimization/lapjv');
    PT_THRES = 6; % joined curve must be long enough
    INTERVAL = 0.1; % used to estimate the curvature
    K_THRES_RATIO = 1.5; % used to construct m2 mat below

    % find end pairs that are close to each other
    pairends = CurveSegment.find_close_ends(Csin,r);
    
    % group the end pairs into sets in which elements are close to
    %   each other
    pairsets = CurveSegment.find_conflict_sets(pairends);
    
    % at most N curves should be linked, pre-allocated memory
    pair2link = zeros(numel(Csin),2); 
    link_ind = 0;
    num_seg = numel(Csin); % num of segments

    % find pair2link, n x 2 mat, which is the solution of linear
    %   assignment problem
    for I = 1:numel(pairsets)
        % current set
        curr_set = pairsets{I};
        % construct assignment matrix for LAPJV
        assign_mat = [];
        make_assign_mat();
        % solve the assignment problem by LAPJV
        [rowsol,assign_cost] = lapjv(assign_mat);
        num_ends = size(curr_set,1);
        for J = 1:num_ends
            if (rowsol(J) <= num_ends) && ...
                    (rowsol(J) > J)
                link_ind = link_ind + 1;
                pair2link(link_ind,:) = ...
                    [curr_set(J),curr_set(rowsol(J))];
            end
        end
    end
    pair2link = pair2link(sum(abs(pair2link),2)~=0,:);
    
    % remove the cycles and multiple links
    pair2link = remove_abnormal_links(pair2link);
    pair2link = remove_abnormal_links(pair2link);

    % find complete link path
    linksets = CurveSegment.find_link_sets(pair2link);
    linked_segs = unique(abs(pair2link(:)));
    lonely_segs = setdiff(1:numel(Csin),linked_segs);
    Csout = {};
    % unmodified segments
    for I = 1:numel(lonely_segs)
        Csout{end+1} = Csin{lonely_segs(I)};
    end
    % linked segments
    for I = 1:numel(linksets)
        curr_path = linksets{I};
        Csout{end+1} = CurveSegment.join_multi_curvesegments(...
            Csin, ...
            curr_path);
    end


    %% helper functions
    % 1. to calculate the distace between two end points
    function pdout = pd(CsinI,CsinJ)
        c1 = Csin{abs(CsinI)};
        c2 = Csin{abs(CsinJ)};
        if CsinI>0 p1 = c1.Start;
        else       p1 = c1.End;
        end
        if CsinJ>0 p2 = c2.Start;
        else       p2 = c2.End;
        end
        pdout = sqrt(sum((p1-p2).^2));
    end

    % 2. construction of the assignment matrix
    % required external info: curr_set, Csin, INTERVAL, r
    % K_THRES_RATIO, k_thres, and PT_THRES
    % just a simple short-hand script
    % IMPORTANT NOTE: the solution of the linear assignment problem
    % is not subject to the symmetry condition, e.g., (i,j) does
    % not necessarily indicate (j,i) is also in the solution.
    % TODO: to find an algo to solve this
    function make_assign_mat
        num_ends = size(curr_set,1); % number of ends
        assign_mat = zeros(2*num_ends,2*num_ends); % [m1,m2;m2,m1']
        m1 = zeros(num_ends,num_ends);
        m2 = zeros(num_ends,num_ends);
        ca = abs(curr_set); % curve index
        cs = sign(curr_set); % start/end index
        % m1
        for ii = 1:(num_ends-1)
            ind1 = ca(ii);
            s1 = Csin{ind1};
            np1 = get_curve_length(s1);
            if cs(ii)>0 
                s1 = rev_curvesegment(s1);
            end
            for jj = (ii+1):num_ends
                ind2 = ca(jj);
                s2 = Csin{ind2};
                np2 = get_curve_length(s2);
                if cs(jj)<0
                    s2 = rev_curvesegment(s2);
                end
                % criterion 1, too short
                if (np1+np2) < PT_THRES
                    continue;
                end
                % criterion 2, the same segment
                if ind1 == ind2
                    continue;
                end
                % criterion 3, because find_conflict_sets func
                % returns pairs that should be disjoint to each
                % other, e.g., original pairs:
                % (1,2), (2,3), and (-2,4), -2 and 4 coincide
                % this would lead to wrong pairs: (1,4),(1,-2)
                % which are far away
                if pd(curr_set(ii),curr_set(jj)) > r
                    continue;
                end
                % criterion 4, normal segment
                s12 = join_curvesegments(s1,s2);
                pp = csaps_curvesegment(s12,spreg);
                % % local curvature
                % t = np1:INTERVAL:(np1+1);
                % k = calc_pp_curvature(pp,t);
                % global curvature
                t = 1:INTERVAL:get_curve_length(s12);
                k = calc_pp_curvature(pp,t);
                kmax = max(abs(k));
                if kmax<k_thres
                    m1(ii,jj) = kmax;
                end
            end
        end
        % for now, I don't know how to solve the symmetric
        % assignment problem
        % m1 = max(cat(3,m1,m1'),[],3);
        m1(m1==0) = inf;
        % m2
        m2 = eye(num_ends) * K_THRES_RATIO * k_thres;
        m2(m2==0) = inf;
        assign_mat = [m1,m2;...
                      m2,m1'];
    end

    function p2l_out = remove_abnormal_links(p2l)
    % p2l: pair2link
    % to remove the cycles in the pair2link
    % e.g., pair1: 1,2 and pair2: -1,2. 
    % These pairs of pairs are the consequences of short segments
        % if isempty(p2l)
        %     p2l_out = p2l;
        %     return;
        % end
        % p2l0 = p2l;
        % [uniq_pairs,IA,IC] = unique(sort(abs(p2l0),2),'row');
        % if size(IA,1)~=size(p2l0,1) % cycles exist
        %     p2l = zeros(max(IC),2);
        %     for I = 1:max(IC)
        %         ab_pairs = p2l0(IC==I,:);
        %         if size(ab_pairs,1)==1
        %             p2l(I,:) = ab_pairs;
        %         elseif size(ab_pairs,1)==2
        %             pd1 = pd(ab_pairs(1,1),ab_pairs(1,2));
        %             pd2 = pd(ab_pairs(2,1),ab_pairs(2,2));
        %             if pd1<pd2
        %                 p2l(I,:) = ab_pairs(1,:);
        %             else
        %                 p2l(I,:) = ab_pairs(2,:);
        %             end
        %         else
        %             % should not be here
        %             % p2l should not contain duplicate pairs
        %             error('resolving cycle failed');
        %         end
        %     end
        % end

        % to remove multiple connection in the p2l
        % e.g., pair1: 1,2 and pair2: 1,3.
        % These pairs of pairs are the consequences of loose
        % constraints, see below note in the make_assign_mat.
        if isempty(p2l)
            p2l_out = p2l;
            return;
        end
        p2l0 = p2l;
        tbl = tabulate(p2l0(:));
        [max_dup,dup_end] = max(tbl(:,2)); % max degree of
                                           % duplicate
        if max_dup > 1 % multiple connection exist
            dup_set = {};
            while size(p2l0,1)>0
                % the loop is executed at least once
                tbl = tabulate(p2l0(:));
                % max degree of duplicate
                [max_dup,dup_end_ind] = max(tbl(:,2));
                dup_end = tbl(dup_end_ind,1);
                % the rows to be dealt with
                dup_row_ind = (p2l0(:,1)==dup_end) ...
                    | (p2l0(:,2)==dup_end);
                dup_set{end+1} = p2l0(dup_row_ind,:);
                p2l0(dup_row_ind,:) = [];
            end
            p2l = zeros(numel(dup_set),2);
            for I = 1:numel(dup_set)
                num_dup = size(dup_set{I},1);
                if num_dup > 1
                    % need resolution
                    pair_dist = zeros(num_dup,1);
                    tmp = dup_set{I};
                    for J = 1:num_dup
                        pair_dist(J) = pd(tmp(J,1),tmp(J,2));
                    end
                    [min_dist,min_ind] = min(pair_dist);
                    p2l(I,:) = tmp(min_ind,:);
                else
                    p2l(I,:) = dup_set{I};
                end
            end
        end
        p2l_out = p2l;
    end

end
