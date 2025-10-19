% t3 = augknt(1:15,4);
t3 = 1:(length(c3(1,:))+3);
sp = spmak(t3,c3);
plot(x3,y3,'.r');
hold on
fnplt(sp,t3([3 16]),2)
plot(c3(1,:),c3(2,:),':ok')
hold off