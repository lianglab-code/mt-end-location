% to test the change of planar curve as the control points change

tic
figure;hold on;axis equal;
nc = 6;
np = 300;
coefs = rand(2,nc)*10;
coefs2 = coefs + rand(2,nc);
k = 4;
knots = 1:(nc-k+2);
knots = augknt(knots,k);
sp = spmak(knots,coefs);
sp2 = spmak(knots,coefs2);
% sp3 = sp;
% sp3.coefs = coefs2;
% sp2 and sp3 are equal!!!

t = linspace(knots(1),knots(end),np);
y = fnval(sp,t);
y2 = fnval(sp2,t);
% y3 = fnval(sp3,t);

plot(y(1,:),y(2,:),'k-','linewidth',4);
plot(y2(1,:),y2(2,:),'r-','linewidth',4);
% plot(y3(1,:),y2(2,:),'b-','linewidth',2);
plot(coefs(1,:),coefs(2,:),'ko--','linewidth',4);
plot(coefs2(1,:),coefs2(2,:),'r*--','linewidth',4);

for ii = 1:np
    plot([y(1,ii) y2(1,ii)],[y(2,ii) y2(2,ii)],'b-','linewidth',1.5);
end
for ii = 1:nc
    plot([coefs(1,ii) coefs2(1,ii)],[coefs(2,ii) coefs2(2,ii)],'m--','linewidth',1.5);
end

toc