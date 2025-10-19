figure;hold on;
for ii = 1:11
l = tmp_lines{ii};
if size(l,1)==2
plot(l(1,:),l(2,:),[str(ii),'-'],'color',ColorSet(ii,:), ...
     'MarkerSize',10,'LineWidth',4);
text(l(1,1),l(2,1),num2str(ii),'FontSize',24);
end
end