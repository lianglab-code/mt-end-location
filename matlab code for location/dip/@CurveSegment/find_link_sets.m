function linksets = find_link_sets(pairends)
%% FIND_LINK_SETS finds pairends to link from a list; it is mainly
% intended to order the linked segments. pairends should have been
% the result of the assignment algorithm.
% 
% linksets = find_link_sets(pairends)
% 
% Input:
% pairends: num_pairs x 2, negative value indicates End of curve,
%           output of find_close_ends.m; should not contain zeros,
%           it should be the output of the 
%
% Output:
% linksets: cell of matrix, num_pairs x 2, negative value 
%           indicates End of curve
%
% Example:
% pairends = [1 2; -2 3; -3 4; 5 6]
% linksets = {[1 2 -3 3 -3 4],[5 6]}
%
% requirement: tabulate [stat toolbox]
    
    % check the requirement of the input
    if(size(pairends,1)==0)
        linksets = {};
        return;
    end
    pairends_tbl = tabulate(pairends(:));
    % if max(pairends_tbl(:,2))>2 ||  min(pairends_tbl(:,2))<1
    if max(pairends_tbl(:,2))>2
        error('input should be resolved by assignment algo first');
    end
    
    % decompose the pairends list to sets
    decom_pairends = {};
    for I = 1:size(pairends,1)
        p1 = pairends(I,1);
        p2 = pairends(I,2);
        s1 = is_in_cell(p1);
        s2 = is_in_cell(p2);
        if s1==0 && s2==0
            decom_pairends{end+1} = [p1,p2];
        elseif s1==0 && s2>0
            decom_pairends{s2} = [decom_pairends{s2};p1,p2];
        elseif s1>0 && s2==0
            decom_pairends{s1} = [decom_pairends{s1};p1,p2];
        elseif s1~=s2
            % maybe ok, if the curve is closed, but i'd rather
            % ignore this
            decom_pairends{s1} = [decom_pairends{s1};...
                                decom_pairends{s2};...
                                p1,p2];
            decom_pairends{s2} = [];
        end
    end

    % remove the empty sets
    tmp_decom_pairends = {};
    for I = 1:numel(decom_pairends)
        if isempty(decom_pairends{I})
            continue;
        end
        tmp_decom_pairends{end+1} = decom_pairends{I};
    end
    decom_pairends = tmp_decom_pairends;
    clear 'tmp_decom_pairends';
    
    % compute the linksets
    linksets = {};
    for I = 1:numel(decom_pairends)
        curr_set = decom_pairends{I};
        curr_path = find_path(curr_set);
        linksets{end+1} = curr_path;
    end
    
    function status = is_in_cell(p)
    % p: scalar
        status = 0;
        for ii = 1:numel(decom_pairends)
            v = decom_pairends{ii};
            v = v(:);
            % is at two ends of the same curve?
            ind = find((p+v)==0); 
            if numel(ind)>0
                status = ii;
                return;
            end
        end
    end
    
    function pathvect = find_path(vect)
    % vect: n x 2 vec, e.g., curr_set above
    % pathvect: 2*n x 1 row vect
        pathvect = [];
        if size(vect,1)==0 return; end
        tbl = tabulate(abs(vect(:)));
        inds = tbl(tbl(:,2)==1); % indics of the connected ends
        if numel(inds) ~= 2
            vect
            error('not a simple path? find_link_sets');
        end
        pathvect = zeros(numel(vect),1);
        % first connected end
        if isempty(find(vect==tbl(inds(1),1),1))
            pathvect(1) = -1*tbl(inds(1),1);
        else
            pathvect(1) = tbl(inds(1),1);
        end
        % last connected end
        if isempty(find(vect==tbl(inds(2),1),1))
            pathvect(end) = -1*tbl(inds(2),1);
        else
            pathvect(end) = tbl(inds(2),1);
        end
        pcurr = pathvect(1); % current end
        vect2 = ones(size(vect));
        for ii = 2:2:(numel(pathvect)-1)
            % assume that one end can only link to another end
            % e.g., numel(vi) == 1
            [vi,vj] = find((pcurr*vect2-vect)==0);
            pathvect(ii) = vect(vi,3-vj);
            pathvect(ii+1) = -1*pathvect(ii);
            pcurr = pathvect(ii+1);
        end
    end

end
