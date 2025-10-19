function C3 = join_segments(C1,C2)
%% JOIN_SEGMENTS joins two curve segments and returns a new one.
%
% C3 = join_segments(C1,C2)
%
% Input:
% C1, C2: two CurveSegment
%
% Output:
% C3: a new CurveSegment

points = [];
if sum(abs(C1.End - C2.Start)) == 0
    points = [C1.Points,C2.Points(:,2:end)];
else
    points = [C1.Points,C2.Points];
end

C3 = CurveSegment(C1.Start,C2.End,points);
