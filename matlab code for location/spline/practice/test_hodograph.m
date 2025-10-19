% This test shows three methods to numerically calculate the
% hodograph of a closed b-spline curve.

k = 4;
nc = 7;
coefs0 = 5*rand(2,nc);
coefs = [coefs0,coefs0(:,1:k-1)];
nk = nc+(k-1)+(k);
knots = 1:nk;
sp0 = spmak(knots,coefs);

figure; hold on; axis equal;
fnplt(sp0,[knots(k),knots(end-k+1)],'r');
plot(coefs(1,1:end-(k-2)),coefs(2,1:(end-(k-2))),'ko:');

% method 1 to construct the hodograph; note the
% evaluation range
sp1 = fnder(sp0);

% method 2 to construct the hodograph; it is assumed that the bases
% is the cardinal b-splines
k2 = k-1;
coefs2 = zeros(2,nc+k2-1); % order k-1
coefs2(:,1) = coefs0(:,1)-coefs0(:,nc);
coefs2(:,2:nc) = coefs0(:,2:nc)-coefs0(:,1:(nc-1));
coefs2(:,nc+1) = coefs0(:,1)-coefs0(:,nc);
coefs2(:,(nc+2):(nc+k2-1)) = coefs2(:,2:(k2-1));
nk2 = nc+(k2-1)+(k2);
knots2 = 1:nk2;
sp2 = spmak(knots2,coefs2);

% numerical derivative of the original spline curve
t = linspace(knots(k),knots(end-k+1),10000);
x = fnval(sp0,t);
xy = x;
dx = diff(xy(1,:));
dy = diff(xy(2,:));
dx = dx/(t(2)-t(1));
dy = dy/(t(2)-t(1));


figure; hold on; axis equal;

% 1
fnplt(sp1,[knots(k),knots(end-k+1)],'r');
plot(sp1.coefs(1,2:(end-1)),sp1.coefs(2,2:(end-1)),'ro:');
% 2
fnplt(sp2,[knots2(k2),knots2(end-k2+1)],'k');
plot(sp2.coefs(1,1:end-(k2-2)),sp2.coefs(2,1:(end-(k2-2))),'k*:');
% numerical
plot(dx,dy,'b','linewidth',3);

% Conclusion:
% 1. three methods are the same.
% 2. the plotted control points are the same!
% 3. the difference between method 2 and 3 lies in the plotting
%    ranges and the knot sequences.
% 4. If only numerical differentiation is required, method 1 is
%    definitely more straight forward and convinent; however, if
%    analytical differeniation is required, e.g., in regularization
%    in the optimization of the b-spline curve in b-spline fitting,
%    it seems that the second method is better? Is it?

