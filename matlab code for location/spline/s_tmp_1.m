t = 1:9;
c = [2 1.4;1 .5; 2 -.4; 5 1.4; 6 .5; 5 -.4].';
sp = spmak(t,c);
fill(c(1,3:5),c(2,3:5),'y','EdgeColor','y');
hold on
fnplt(sp,t([3 7]),1.5)
fnplt(sp,t([5 6]),3)
plot(c(1,:),c(2,:),':ok')
text(2,-.55,'a(:,i-2)','FontSize',12)
text(5,1.6,'a(:,i-1)','FontSize',12)
text(6.1,.5,'a(:,i)','FontSize',12)
title('The Convex-Hull Property')
axis([.5 7 -.8 1.8])
axis off
hold off