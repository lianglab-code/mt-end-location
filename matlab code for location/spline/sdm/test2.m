ColorSet = varycolor(Imax*Jmax);

[M,N] = size(p);
figure; hold on;
for i = 1:N
    plot(p(1,i),p(2,i),'.','Color',ColorSet(pg(i),:));
end
axis equal;
hold off;
