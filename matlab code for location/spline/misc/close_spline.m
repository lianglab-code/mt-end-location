function sp = close_spline(c,varargin)
%% CLOSE_SPLINE generate a closed/periodic spline from 
% the control points c and order ord. The knots of the returned
% spline are uniformally distributed. The spline is not periodic.
% The domain of sp is [sp.knots(k),sp.knots(end-k+1)]

% INPUT
% c: control points
% k: spline order (optional, default: 4);

% OUTPUT
% sp: B-form splines

% NOTE:
% the input control points should not overlap, otherwise the 
% the continuity condition would be violated.

% TODO:
% 1. to modify the program to accept the non-uniform knots as an
% input ((PGS, p282)

% Example to use the output sp:
% 1d:
% knots = sp.knots;
% k = sp.order;
% t = aveknt(knots,k);
% fnplt(sp,[knots(k),knots(end-k+1)]); hold on;
% plot(t(1:length(c)),c,'ro-');
    
% 2d: 
% plot(control_points(1,:),control_points(2,:),'ro-');
% hold on;
% fnplt(sp,[sp.knots(4) sp.knots(end-3)]);

if length(varargin)==0
    k = 4;
elseif length(varargin)==1
    k = varargin{1};
else
    error('Usage: sp = close_spline_2d(c)\n');
end

% dimension of control points
[M,N] = size(c);
d = min([M N]);

% dimension of c should be d*N
n = M*N/d; % # of control points
c = reshape(c,d,n);

% wrap the control points
n = n+3;
c = [c c(:,1:(k-1))];
t = linspace(0,1,n+k);
knots = t;
sp = spmak(knots, c);

end