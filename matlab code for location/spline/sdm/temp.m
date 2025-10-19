% 0
% used to plot the b-spline
t0 = linspace(knots(k),knots(end-k+1),200);
c0 = fnval(sp0,t0);
figure;
plot(ps(1,:),ps(2,:),'ro');
hold on;axis equal;
plot(c0(1,:),c0(2,:),'b-');
plot([coefs(1,:),coefs(1,1)],...
     [coefs(2,:),coefs(2,1)],...
     'ko--','linewidth',2);
quiver(ps(1,:),ps(2,:),...
       c1(1,:)-ps(1,:),...
       c1(2,:)-ps(2,:), 0);
% tdm
quiver(c1(1,:),c1(2,:),cn(1,:),cn(2,:),0)
quiver(c1(1,:),c1(2,:),csn(1,:),csn(2,:),0)
% tdm
dcoefs = reshape(D,2,m);
coefs_new = coefs+dcoefs;
sp_new = spmak(knots,[coefs_new,coefs_new(:,1:k-1)]);
c0_new = fnval(sp_new,t0);
plot(c0_new(1,:),c0_new(2,:),'b-','linewidth',3);
plot([coefs_new(1,:),coefs_new(1,1)],...
     [coefs_new(2,:),coefs_new(2,1)],...
     'ko--','linewidth',4);


% 1 untitled.eps
% to check each segment
figure;hold on;axis equal;
tmp_num_seg = size(sp.coefs,2);
tmp_ColorSet = varycolor(tmp_num_seg);
tmp_str = cell(tmp_num_seg,1);
for ii = 1:tmp_num_seg
    tmp_t = linspace(knots(ii),knots(ii+k-1),200);
    tmp_xy = fnval(sp,tmp_t);
    plot(tmp_xy(1,:),tmp_xy(2,:),'-',...
         'linewidth',2,...
         'color',tmp_ColorSet(ii,:));
    tmp_str{ii} = num2str(ii);
end
legend(tmp_str{:});
for ii = 1:tmp_num_seg
    tmp_xy = fnval(sp,knots(ii));
    plot(tmp_xy(1,:),tmp_xy(2,:),'o',...
         'markersize',8,...
         'color',tmp_ColorSet(ii,:),...
         'markerfacecolor',tmp_ColorSet(ii,:));
end

