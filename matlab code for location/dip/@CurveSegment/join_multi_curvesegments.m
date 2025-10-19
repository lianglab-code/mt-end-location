function Cout = join_multi_curvesegments(Csin,link_path)
%% JOIN_MULTI_CURVESEGMENTS joins several segments of Csin and
% output the linked segment Cout.
%
% Cout = join_multi_curvesegments(Csin,link_path)
%
% Input:
% Csin: cell of CurveSegment
% link_path: vector of ordered end points, e.g, [1 2 -2 -3 3]
%            output of the find_link_sets.m
%
% Output:
% Cout: the linked segment
%
    num_seg = numel(Csin);
    num_end = numel(link_path);
    ind_seg = abs(link_path); % segment index
    sgn_end = sign(link_path); % the start/end of the segment
    
    I = 1;
    seg = Csin{ind_seg(I)};
    if sgn_end(I) > 0
        seg = rev_curvesegment(seg);
    end
    
    for I = 2:2:(numel(link_path)-1)
        if (link_path(I)+link_path(I+1)) ~= 0
            error('link_path is not a qualified link path');
            return;
        end
        new_seg = Csin{ind_seg(I)};
        if sgn_end(I) < 0
            new_seg = rev_curvesegment(new_seg);
        end
        seg = join_curvesegments(seg,new_seg);
    end
    
    I = numel(link_path);
    new_seg = Csin{ind_seg(I)};
    if sgn_end(I) < 0
        new_seg = rev_curvesegment(new_seg);
    end
    seg = join_curvesegments(seg,new_seg);
    Cout = seg;
end
