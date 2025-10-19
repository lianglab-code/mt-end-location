load '../sdm/test.mat';
ps = [x';y'];
ps = ps(:,randi(size(ps,2),floor(size(ps,2)/5),1));
tic
[d,t] = dist_points_sp_brute(ps,sp);
toc

coefs = sp.coefs;
knots = sp.knots;
k = sp.order;
np = size(ps,2);

plotx = linspace(knots(k),knots(end-k+1),1000);
ploty = fnval(sp,plotx);

figure;
hold on;
axis equal;
% plot(x,y,'ko');
plot(ploty(1,:),ploty(2,:),'r-','linewidth',10);

% 
ps2 = fnval(sp,t);
for ii = 1:np
    % point-to-curve dist
    plot([ps(1,ii) ps2(1,ii)],[ps(2,ii) ps2(2,ii)],'ko-','MarkerSize', ...
         6,'MarkerFaceColor','k');
    % closest points on the curve
    % plot(p2(1,ii),p2(2,ii),'mo-','MarkerSize',8,'MarkerFaceColor', ...
    %     'm');
end
