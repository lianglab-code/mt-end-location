k = 4;
n = 8;

% original
c1 = rand(1,n);
c1(end) = c1(1);
t1 = zeros(1,n-k+2);
t1(1) = rand;
for ii = 2:(n-k+2)
    t1(ii) = t1(ii-1)+rand;
end
knot1 = augknt(t1,k);
sp1 = spmak(knot1,c1);
figure;
% fnplt(sp1,[knot1(k),knot1(n+1)],'r');
hold on;
g1 = zeros(1,n);
for ii = 1:n
    g1(ii) = sum(knot1((ii+1):(ii+k-1)))/(k-1);
end
plot(g1,c1,'ko--');
x1 = linspace(t1(1),t1(end),3000);
y1 = fnval(sp1,x1);
plot(x1,y1,'b.');
hold off;


% % extended
% period = (t1(end)-t1(1))*1.2;
% c2 = [c1,c1]; % 2*n-1
% t2 = [t1(end-1:end)-period,t1,t1+period];
% knot2 = augknt(t2,k);
% sp2 = spmak(knot2,c2);
% g2 = zeros(1,2*n-1);
% for ii = 1:2*n
%     g2(ii) = sum(knot2((ii+1):(ii+k-1)))/(k-1);
% end
% % figure;
% hold on;
% plot(g2,c2,'mo--');
% x2 = linspace(t2(1),t2(end),2*3000);
% y2 = fnval(sp2,x2);
% plot(x2,y2,'r.');
% hold off;

% x21 = linspace(t2(3),t2(3+6-1),2*3000);
% y21 = fnval(sp2,x21);
% x22 = linspace(t2(3+6),t2(3+6+6-1),2*3000);
% y22 = fnval(sp2,x22);
% plot(x21,y21,'ko');
% hold on;
% plot(x22-period,y22,'r.');

figure;
% extended 2
period = t1(end)-t1(1);
% c3 = [c1((n-3+1):end) c1(4:end) c1(2:end)]; % period: t1(1:end-1)
c3 = [c1 c1(2:end)]; % period: t1(1:end-1)
% t3 = [ knot1(n-3+1)-period knot1(n-3+2)-period knot1(n-3+3)-period ...
%        knot1(4:n+1) ...
%        knot1(4:n+1)+period ...
%        repmat(knot1(4)+2*period, [1 4])];
t3 = [ knot1(n-3+1)-period knot1(n-3+2)-period knot1(n-3+3)-period ...
       knot1(4:n+1) ...
       knot1(4:n+1)+period ...
       knot1(5:8)+2*period];
knot3 = t3;
sp3 = spmak(knot3,c3);
x3 = linspace(knot3(4),knot3(end-3),3*3000);
y3 = fnval(sp3,x3);
plot(x3,y3,'ro');
x31 = linspace(knot3(4),knot3(n+1),1000);
y31 = fnval(sp3,x31);
x32 = linspace(knot3(n+1),knot3(n*2),1000);
y32 = fnval(sp3,x32);
hold on;
plot(x31,y31,'g.');
plot(x32,y32,'k.');
plot(x32-period,y32,'b.');
g3 = zeros(1,size(c3,2));
for ii = 1:size(c3,2)
    g3(ii) = sum(knot3((ii+1):(ii+k-1)))/(k-1);
end
plot(g3,c3,'ko--');
hold off;