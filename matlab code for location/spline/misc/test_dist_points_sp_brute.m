np = 20; % number of points
nc = 10; % number of coefs
rf = 2; % random factor
coefs = [10+10*rand(1,nc);10+10*rand(1,nc)];
knots = 1:(nc+4-6);
knots = augknt(knots,4);
sp = spmak(knots,coefs);
k = sp.order;

% x y for plotting
x = linspace(knots(k),knots(end-k+1),1000);
y = fnval(sp,x);
% x2 y2 for generating testing points
x2 = linspace(knots(k),knots(end-k+1),np);
y2 = fnval(sp,x2);

figure;
plot(y(1,:),y(2,:),'-','linewidth',3);
hold on;axis equal;
% plot(coefs(1,:),coefs(2,:),'ro-','linewidth',2); % control polygon
p = [y2(1,:)+rf*rand(1,np);y2(2,:)+rf*rand(1,np)];
p2 = zeros(2,np);
tic
[d,t] = dist_points_sp_brute(p,sp);
toc
p2 = fnval(sp,t);

ColorSet = varycolor(np);
% ct = calc_sp_tangent(sp,t);
% cn = calc_sp_normal(sp,t);
% csc = calc_sp_curvature(sp,t);
[ct,cn,csc] = calc_sp_tnc(sp,t);
cc = p2 + cn.*repmat(1./csc,2,1);
[cx,cy] = gen_circ(cc,abs(1./csc));

for ii = 1:np
    % point-to-curve dist
    plot([p(1,ii) p2(1,ii)],[p(2,ii) p2(2,ii)],'ko-','MarkerSize', ...
         10,'MarkerFaceColor','k');
    % closest points on the curve
    plot(p2(1,ii),p2(2,ii),'mo-','MarkerSize',8,'MarkerFaceColor', ...
         'm');
    % center of curvature
    plot(cx(ii,:),cy(ii,:),'color',ColorSet(ii,:),'LineWidth',1.5);
    % curvature circle
    plot([p2(1,ii),cc(1,ii)],[p2(2,ii),cc(2,ii)],'o-', ...
         'MarkerSize',6,'MarkerFaceColor', ...
         ColorSet(ii,:), 'Color',ColorSet(ii,:));
end
