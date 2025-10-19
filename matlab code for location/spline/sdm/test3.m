is_closed = true;
knots = sp.knots;
k = 4;

% initial b-spline:
% gen sp0

% debug
% plot(x,y,'k-');
plot(noisy_x,noisy_y,'ro');
hold on;axis equal;
t0 = linspace(knots(k),knots(end-k+1),200);
c0 = fnval(sp,t0);
plot(c0(1,:),c0(2,:),'b-');
% debug

% input
ps = [noisy_x;noisy_y];
iter_max = 100;

for ii = 1:iter_max
% step 01: calc foot points
[d,t] = dist_points_sp_brute(ps,sp);

% step 02: calc control point displacements
[ct,cn,csc] = calc_sp_tnc(sp,t);
end