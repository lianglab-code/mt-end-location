function pp = csaps_curvesegment(C1,varargin)
%% CSAPS_CURVESEGMENT calculates the spline from the curve setment
%
% pp = csaps_curvesegment(C1)
%
% INPUT:
% C1: CurveSegment
% spreg: regularization, default 0.1
% 
% OUTPUT:
% pp: spline

spreg = 0.1;
if nargin>1
    spreg = varargin{1};
end

np = size(C1.Points,2);

t = 1:np;
pp = csaps(t,C1.Points);
