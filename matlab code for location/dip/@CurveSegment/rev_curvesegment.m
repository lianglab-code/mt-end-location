function C2 = rev_segment(C1)
%% REV_SEGMENT join reverses the segment
%
% C2 = rev_segment(C1)
%
% Input:
% C1: a CurveSegment
%
% Output:
% C2: the reversed CurveSegment

C2 = CurveSegment(C1.End,C1.Start,C1.Points(:,end:-1:1));
