tic
figure;hold on;axis equal;
nc = 10;
coefs = rand(2,nc)*10;
coefs2 = coefs + rand(2,nc);
k = 4;
knots = 1:(nc-k+2);
knots = augknt(knots,k);
sp = spmak(knots,coefs);
sp2 = spmak(knots,coefs2);
sp3 = sp;
sp3.coefs = coefs2;

t = linspace(knots(1),knots(end),300);
y = fnval(sp,t);
y2 = fnval(sp2,t);
y3 = fnval(sp3,t);

plot(y(1,:),y(2,:),'k-','linewidth',2);
plot(y2(1,:),y3(2,:),'m-','linewidth',4);
plot(y3(1,:),y2(2,:),'b-','linewidth',2);
plot(coefs(1,:),coefs(2,:),'ko-','linewidth',2);
plot(coefs2(1,:),coefs2(2,:),'m*--','linewidth',4);



toc