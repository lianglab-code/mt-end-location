function Csout = remove_short_curvesegments(Csin,l)
%% REMOVE_SHORT_CURVESEGMENTS removes CurveSegments shorter than l
%
% Csout = remove_short_curvesegments(Csin,l)
%
% Input:
% Csin: cell of CurveSegment
% l: length threshold
%
% Output:
% Csout: cell of CurveSegment longer than length threshold

    nc = numel(Csin);
    Csout = {};
    for I = 1:nc
        c = Csin{I};
        if get_curve_length(c)>l
            Csout{end+1} = c;
        end
    end

end
