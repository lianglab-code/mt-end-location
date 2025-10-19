classdef CurveSegment
% a curve segment is a non-branching curve
    properties
        Start  % start point, 2x1 or 3x1 vec
        End    % end point, 2x1 or 3x1 vec
        Points % points, including start and end points, 2xnp or
               % 3xnp vec
    end
    
    methods
        function obj = CurveSegment(Start,End,Points)
            obj.Start = [];
            obj.End = [];
            obj.Points = [];
            if sum(abs(Start-Points(:,1))) ~= 0 || ...
                    sum(abs(End-Points(:,end))) ~= 0
                error('inconsistent start or end points');
                return;
            end
            obj.Start = Start;
            obj.End = End;
            obj.Points = Points;
        end
    end
    methods
        C3 = join_curvesegments(C1,C2);
        Cs = break_curvesegment(C,k_num,k_thres,spreg);
        C2 = rev_curvesegment(C1);
        pp = csaps_curvesegment(C1,spreg);
        function l = get_curve_length(C)
            l = size(C.Points,2);
            % to remove the coinciding start/end ends
            if sum((C.Start-C.End).^2)==0
                l = l-1;
            end
        end
    end
    methods (Static)
        pairends = find_close_ends(Cs,r);
        pairsets = find_conflict_sets(pairends);
        linksets = find_link_sets(pairends);
        Cout = join_multi_curvesegments(Csin,link_path);
        Csout = link_curvesegments(Csin,r,k_thres,spreg);
        Cs = binary_to_curvesegment(bin_img,nng_r);
        Csout = remove_short_curvesegments(Csin,l);
    end
end
