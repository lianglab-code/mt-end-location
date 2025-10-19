function pairsets = find_conflict_sets(pairends)
%% FIND_CONFLICT_SETS finds sets of conflict endpoints
%
% pairsets = find_conflict_sets(pairends)
%
% Input:
% pairends: num_pairs x 2, negative value indicates End of curve,
%           output of find_close_ends.m; should not contain zeros
%
% Output:
% pairsets: cell of matrix, num_pairs x 2, negative value 
%           indicates End of curve
%

    pairsets = {};
    pairsets0 = {};

    for I = 1:size(pairends,1)
        p1 = pairends(I,1);
        p2 = pairends(I,2);
        s1 = is_in_cell(p1);
        s2 = is_in_cell(p2);
        if s1==0 && s2==0
            pairsets0{end+1} = [p1;p2];
        elseif s1==0 && s2>0
            pairsets0{s2} = [pairsets0{s2};p1];
        elseif s1>0 && s2==0
            pairsets0{s1} = [pairsets0{s1};p2];
        elseif s1~=s2
            % error('something wrong?');
            pairsets0{s1} = [pairsets0{s1};pairsets0{s2}];
            pairsets0{s2} = [];
        end
    end

    for I = 1:numel(pairsets0)
        if isempty(pairsets0{I})
            continue;
        end
        pairsets{end+1} = pairsets0{I};
    end

    function status = is_in_cell(p)
    % p: scalar
        status = 0;
        for jj = 1:numel(pairsets0)
            v = pairsets0{jj};
            if isempty(v)
                continue;
            end
            % is at the same end of the same curve?
            ind = find((p-v)==0);
            if numel(ind)>0
                status = jj;
                return;
            end
        end
    end
    
end
