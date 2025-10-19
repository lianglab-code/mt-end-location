tic
np = 20; % number of points
nc = 10; % number of coefs
rf = 2; % random factor
rf2 = 0.1; % random factor, change of coefs, to test the
           % dist_points_sp_guess
coefs = [10+10*rand(1,nc);10+10*rand(1,nc)];
knots = 1:(nc+4-6);
knots = augknt(knots,4);
sp = spmak(knots,coefs);
k = sp.order;

% x y for plotting
x = linspace(knots(k),knots(end-k+1),1000);
y = fnval(sp,x);
% x2 y2 for generating testing points
xx = linspace(knots(k),knots(end-k+1),np);
yy = fnval(sp,x2);

figure;
plot(y(1,:),y(2,:),'-','linewidth',3);
hold on;axis equal;
% plot(coefs(1,:),coefs(2,:),'ro-','linewidth',2); % control polygon
p = [yy(1,:)+rf*rand(1,np);yy(2,:)+rf*rand(1,np)];
pp = zeros(2,np);
[d,t] = dist_points_sp_brute(p,sp);
pp = fnval(sp,t);

for ii = 1:np
    % point-to-curve dist
    plot([p(1,ii) pp(1,ii)],[p(2,ii) pp(2,ii)],'ko-','MarkerSize', ...
         10,'MarkerFaceColor','k');
    % closest points on the curve
    plot(pp(1,ii),pp(2,ii),'mo-','MarkerSize',8,'MarkerFaceColor', ...
         'm');
end

coefs2 = coefs + [rf2*rand(1,nc);rf2*rand(1,nc)];
sp2 = spmak(knots,coefs2);
[d2,t2] = dist_points_sp_guess(p,sp2,t);

y2 = fnval(sp2,x);
plot(y2(1,:),y2(2,:),':','linewidth',3);
pp2 = fnval(sp2,t2);
for ii = 1:np
    % point-to-curve dist
    plot([p(1,ii) pp2(1,ii)],[p(2,ii) pp2(2,ii)],'ko:','MarkerSize', ...
         10,'MarkerFaceColor','k');
    % closest points on the curve
    plot(pp2(1,ii),pp2(2,ii),'go:','MarkerSize',8,'MarkerFaceColor', ...
         'g');
end

toc
