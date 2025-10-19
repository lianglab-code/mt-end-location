function P = make_pointer()

% source:
% http://matlab.izmiran.ru/help/techdoc/creating_plots/figure12.html

P = ones(16)+1;
P(1,:) = 1; P(16,:) = 1;
P(:,1) = 1; P(:,16) = 1;
P(1:4,8:9) = 1; P(13:16,8:9) = 1;
P(8:9,1:4) = 1; P(8:9,13:16) = 1;
P(5:12,5:12) = NaN; % Create a transparent region in the center
