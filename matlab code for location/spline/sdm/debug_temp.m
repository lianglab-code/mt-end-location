% debug begin
figure;
plot(ps(1,:),ps(2,:),'ko');
hold on;
axis equal;
ColorSet = varycolor(iter_max);
t0 = linspace(knots(k),knots(end-k+1),200);
xy = fnval(sp,t0);
plot(xy(1,:),xy(2,:),'ro-','markersize',3,'markerfacecolor','r','linewidth',3);
plot([coefs(1,:),coefs(1,1)],[coefs(2,:),coefs(2,1)],'ro--','markersize',3,'markerfacecolor','k','linewidth',3);
% debug end

% debug begin
figure;
[d,t] = dist_points_sp_brute(ps,sp);
xy0 = fnval(sp,t);
tmpx = [ps(1,:);xy0(1,:);nan(1,n)];
tmpx = reshape(tmpx,1,prod(size(tmpx)));
tmpy = [ps(2,:);xy0(2,:);nan(1,n)];
tmpy = reshape(tmpy,1,prod(size(tmpy)));
plot(ps(1,:),ps(2,:),'k.');
hold on;
plot(tmpx, tmpy, 'k-');
plot([coefs(1,:),coefs(1,1)],[coefs(2,:),coefs(2,1)],'k*--');
axis equal;
% debug end

    % debug begin
    xy = fnval(sp,t);
    xy0 = fnval(sp,t0);
    plot(xy0(1,:),xy0(2,:),'-','color',ColorSet(ii,:));
    tmpx = [ps(1,:);xy(1,:);nan(1,n)];
    tmpx = reshape(tmpx,1,prod(size(tmpx)));
    tmpy = [ps(2,:);xy(2,:);nan(1,n)];
    tmpy = reshape(tmpy,1,prod(size(tmpy)));
    plot(tmpx, tmpy, '-','color',ColorSet(ii,:));

    % hold on;
    % plot(ps(1,:),ps(2,:),'k.');
    plot([coefs(1,:),coefs(1,1)],[coefs(2,:),coefs(2,1)],'*--',...
         'color',ColorSet(ii,:),...
         'markersize',6,...
         'linewidth',3,...
         'markerfacecolor',ColorSet(ii,:));
    % debug end

        % subplot(2,3,ii);
    % xy = fnval(sp,t0);
    % plot(xy(1,:),xy(2,:),'-','color',ColorSet(ii,:));
    % tmpx = [ps(1,:);xy(1,:);nan(1,n)];
    % tmpx = reshape(tmpx,1,prod(size(tmpx)));
    % tmpy = [ps(2,:);xy(2,:);nan(1,n)];
    % tmpy = reshape(tmpy,1,prod(size(tmpy)));
    % plot(tmpx, tmpy, '-','color',ColorSet(ii,:));

    % % hold on;
    % % plot(ps(1,:),ps(2,:),'k.');
    % plot([coefs(1,:),coefs(1,1)],[coefs(2,:),coefs(2,1)],'*--',...
    %      'color',ColorSet(ii,:),...
    %      'markersize',6,...
    %      'linewidth',3,...
    %      'markerfacecolor',ColorSet(ii,:));
    % quiver(coefs(1,:)-dcoefs(1,:), ...
    %        coefs(2,:)-dcoefs(2,:), ...
    %        dcoefs(1,:),...
    %        dcoefs(2,:),...
    %        0,...
    %        'color',ColorSet(ii,:)...
    %        );
    % plot(coefs(1,1),coefs(2,1),'r.','markersize',20);
    % hold off;
    % axis equal;
    drawnow;
    % debug end 
