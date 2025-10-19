r = 2; % window size
s = 8; % image size
g = rand(s,s);
ng = s*s;

g2 = filter_minmax_2d(g,'min',r);
g3 = filter_minmax_2d(g,'max',r);

figure;imshow(g,[0 1]);set(gca,'position',[0 0 1 1]);
hold on;
for ii = 1:ng
    [y,x] = ind2sub([s,s],ii);
    text(x-0.2,y-0.2,num2str(g(ii)),'color','r');
end
hold off;

figure;imshow(g2,[0 1]);set(gca,'position',[0 0 1 1]);
hold on;
for ii = 1:ng
    [y,x] = ind2sub([s,s],ii);
    text(x-0.2,y-0.2,num2str(g2(ii)),'color','r');
end
hold off;

figure;imshow(g3,[0 1]);set(gca,'position',[0 0 1 1]);
hold on;
for ii = 1:ng
    [y,x] = ind2sub([s,s],ii);
    text(x-0.2,y-0.2,num2str(g3(ii)),'color','r');
end
hold off;
